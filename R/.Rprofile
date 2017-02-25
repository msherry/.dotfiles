# https://stackoverflow.com/questions/1189759/

r <- getOption("repos")             # hard code a US repo for CRAN
r["CRAN"] <- "https://cran.cnr.berkeley.edu/"
options(repos = r)
rm(r)


f = pipe("uname")
if (.Platform$GUI == "X11" && readLines(f)=="Darwin") {
  # http://www.rforge.net/CarbonEL/
  library("grDevices")
  options(device='quartz')
  Sys.unsetenv("DISPLAY")
}
close(f); rm(f)


# wideScreen <- function(howWide=Sys.getenv("COLUMNS")) {
#   options(width=as.integer(howWide))
# }
# wideScreen()
