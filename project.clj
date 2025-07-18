(defproject evalback "0.2.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "https://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "https://www.eclipse.org/legal/epl/epl-v10.html"}
  :plugins [[lein-ring "0.12.6"]]
  :java-source-paths ["src/java"]
  ;;:repositories [["snaps" "https://oss.sonatype.org/content/repositories/snapshots/"]]
  :dependencies [
                 [ch.qos.logback/logback-classic "1.5.18"]
                 [org.clojure/clojure "1.12.1"]
                 [compojure "1.7.1"]
                 [org.clojure/data.json "2.5.1"]
                 [org.clojure/core.async "1.8.741"]
                 [de.hhu.stups/prob-java "4.15.0"]
                 [de.hhu.stups/tla2bAST "1.4.2"] ; Can be removed once prob-java is updated
                 [hiccup "2.0.0"]
                 [ring/ring-core "1.13.0"]
                 ]
  :main evalback.core
  :ring {:handler evalback.core/handler
         :init evalback.core/init
         :destroy evalback.core/destroy
         :uberwar-name "evalB.war"}
  :aot :all)
