#!/bin/bash

TIMEOUT=gtimeout

# The file at this location will be updated by an external process (e.g. emacs)
# to indicate that a sync is required
UPDATE_FILE_PATH=/tmp/offlineimap_sync_required

MAILDIR_IMAGE_FILE=~/Dropbox/Mail/Maildir.sparsebundle

SECS_BETWEEN_SYNCS=$(( 5 * 60 ))
FAILURE_WAIT_SECS=60
MAX_RUN_TIME=5m

LAST_SYNC_TIME=0
SECS_UNTIL_SCHEDULED=

# Make sure our update file exists and has a reasonable update time
touch $UPDATE_FILE_PATH

if [ -n "$1" ]; then
    # Custom minutes between syncs
    SECS_BETWEEN_SYNCS=$(( $1 * 60 ))
fi

echo "$SECS_BETWEEN_SYNCS seconds between syncs"

# Return the current date/time in seconds since the epoch
epoch()
{
    date '+%s'
}

# How many seconds remain until a regularly-scheduled sync should be
# performed. If <= 0, then we need to sync
secs_until_scheduled_sync()
{
    # http://stackoverflow.com/a/13864829/52550
    if [ -z ${LAST_SYNC_TIME+x} ]; then
        echo 0
        return
    fi
    now=$(epoch)
    echo $(( LAST_SYNC_TIME + SECS_BETWEEN_SYNCS - now ))
}

# Determine if a local update has happened since our last sync, requiring a new
# sync. Uses the file referenced by UPDATE_FILE_PATH as a sync file -- if not
# present or the update time is before LAST_SYNC_TIME, exit with 1. Otherwise,
# the file is present and updated after our last sync, so exit with 0 to
# indicate that a sync is required. Make sure that the file is at least 30
# seconds old, to account for the possibility of multiple updates being done in
# quick succession.
updated()
{
    if [ ! -f $UPDATE_FILE_PATH ]; then
        echo "No update file found"
        return 1
    fi

    # TODO: This is BSD-specific. Linux would use `stat -c %Y`
    file_update_time=$(stat -f %m $UPDATE_FILE_PATH)
    now=$(epoch)
    # [ $file_update_time -gt $LAST_SYNC_TIME ] && \
    #     [ $file_update_time -lt $(( $now - 30 )) ] # At least 30 seconds have
    #                                                # elapsed since last update
    if [ "$file_update_time" -le $LAST_SYNC_TIME ]; then
        return 1
    fi
    # echo "Update detected"
    if [ "$file_update_time" -lt $(( now - 30 )) ]; then
        # echo "... and it was at least 30 seconds ago"
        return 0
    fi
    # echo "... but it was too recent"
    return 1
}

# Check for regularly-scheduled or force-update syncs, update
# $SECS_UNTIL_SCHEDULED
should_sync()
{
    # Scheduled sync
    SECS_UNTIL_SCHEDULED=$(secs_until_scheduled_sync)
    if [ "$SECS_UNTIL_SCHEDULED" -le 0 ]; then
        echo "Scheduled sync"
        return 0
    fi

    # Force sync
    if updated; then
        echo "Forced sync"
        return 0
    fi
    return 1
}

do_sync()
{
    for _acct_root in $(grep localfolders ~/.offlineimaprc |cut -f2 -d'='); do
        _root="${_acct_root/#\~/$HOME}" # expand ~ without using eval
        if ! [ -e "$_root/canary" ]; then
            echo "No canary file found for $_root ($_root/canary), please check that maildirs are mounted"
            exit 1
        fi
    done
    $TIMEOUT --foreground --signal=KILL $MAX_RUN_TIME bash -c "offlineimap -o"
}

while true; do
    last_min_remaining=0
    while ! should_sync; do
        min_remaining=$(( ( SECS_UNTIL_SCHEDULED + 59 ) / 60 ))
        if [ $min_remaining -ne $last_min_remaining ]; then
            [ $min_remaining = 1 ] && noun="minute" || noun="minutes"
            echo "Next scheduled refresh in $min_remaining $noun..."
        fi
        last_min_remaining=$min_remaining
        sleep 7
    done
    # TODO: Check if the maildir image is mounted, mount it

    # Sync. If we succeed, updated our last sync'd time so we schedule a new
    # sync in SECS_BETWEEN_SYNCS seconds. If we fail, update our last sync'd
    # time to FAILURE_WAIT_SECS seconds before a new sync is due, so we try
    # again shortly (but not immediately).
    do_sync && LAST_SYNC_TIME=$(epoch) || LAST_SYNC_TIME=$(( $(epoch) - SECS_BETWEEN_SYNCS + FAILURE_WAIT_SECS ))
    sleep 5
done
