FROM clojure:openjdk-8-lein AS base
COPY . /app
WORKDIR /app
RUN lein ring uberjar

FROM adoptopenjdk/openjdk12:alpine
WORKDIR /app
COPY examples /app/examples
COPY --from=base  /app/target/evalback-*-standalone.jar /app/evalb.jar
# The probcli.sh shebang specifically says bash and not sh.
RUN apk add bash
CMD ["java", "-jar", "/app/evalb.jar"]
EXPOSE 3000
