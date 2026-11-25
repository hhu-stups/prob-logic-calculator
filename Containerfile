FROM docker.io/library/clojure:temurin-17-lein AS base
WORKDIR /app
COPY project.clj /app/
RUN lein deps
COPY src /app/src
COPY resources /app/resources
RUN lein ring uberjar

FROM docker.io/library/amazoncorretto:21
WORKDIR /app
COPY examples /app/examples
COPY --from=base /app/target/evalback-*-standalone.jar /app/evalb.jar
CMD ["java", "-jar", "/app/evalb.jar"]
EXPOSE 3000
