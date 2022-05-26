import go
import TestUtilities.InlineExpectationsTest

class LoggerTest extends InlineExpectationsTest {
  LoggerTest() { this = "LoggerTest" }

  override string getARelevantTag() { result = "logger" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(LoggerCall log |
      log.hasLocationInfo(file, line, _, _, _) and
      element = log.toString() and
      value = log.getAMessageComponent().toString() and
      tag = "logger"
    )
  }
}
