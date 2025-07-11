FROM clojure:temurin-8-lein AS base
COPY . /app
WORKDIR /app
RUN lein ring uberjar

FROM eclipse-temurin:21
WORKDIR /app
COPY examples /app/examples
COPY --from=base  /app/target/evalback-*-standalone.jar /app/evalb.jar
CMD ["java", "-jar", "/app/evalb.jar"]
EXPOSE 3000
