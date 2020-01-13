print "Configure logger"
import static ch.qos.logback.classic.Level.INFO
import ch.qos.logback.classic.encoder.PatternLayoutEncoder
import ch.qos.logback.core.ConsoleAppender

appender("CONSOLE", ConsoleAppender) {
  encoder(PatternLayoutEncoder) {
    pattern = "%-4relative - %msg%n"
  }
}
root(INFO, ["CONSOLE"])