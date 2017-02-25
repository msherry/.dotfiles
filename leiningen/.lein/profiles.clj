{:user {:plugins [[lein-pprint "1.1.2"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}
        :dependencies [[slamhound "1.5.5"]
                       [pjstadig/humane-test-output "0.8.1"]
                       [aprint "0.1.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)
                     (use 'aprint.core)
                     (require '[clojure.reflect :as r])
                     (use '[clojure.pprint :only [print-table]])]
        :require [clojure/reflect :as r]}}
