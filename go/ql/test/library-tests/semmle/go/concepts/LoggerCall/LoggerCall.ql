import go
import TestUtilities.InlineExpectationsTest

class LoggerTest extends InlineExpectationsTest {
  LoggerTest() { this = "LoggerTest" }

  override string getARelevantTag() { result = "logger" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(LoggerCall log |
      log.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = log.toString() and
      value = log.getAMessageComponent().toString() and
      tag = "logger"
    )
  }
}
