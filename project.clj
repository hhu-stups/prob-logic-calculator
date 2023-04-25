(defproject evalback "0.2.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :plugins [[lein-ring "0.12.5"]]
  :java-source-paths ["src/java"]
  :repositories [["snaps" "https://oss.sonatype.org/content/repositories/snapshots/"]]
  :dependencies [
                 [org.clojure/clojure "1.8.0"]
                 [compojure "1.6.1"]
                 [org.clojure/data.json "0.2.6"]
                 [org.clojure/core.async "0.4.490"]
; TODO: remove tla2BAST SNAPSHOT dependency once prob2.kernel
;; contains a released version 1.1.5 of tla2BAST
                 [de.hhu.stups/tla2bAST "1.1.5-SNAPSHOT"]
                 [de.hhu.stups/de.prob2.kernel "3.15.0"]
                 [hiccup "1.0.5"]
                 [ring/ring-core "1.7.1"]
                 ]
  :main evalback.core
  :ring {:handler evalback.core/handler
         :init evalback.core/init
         :destroy evalback.core/destroy
         :uberwar-name "evalB.war"}
  :aot :all)
