import go
import TestUtilities.InlineExpectationsTest

class UntrustedFlowSourceTest extends InlineExpectationsTest {
  UntrustedFlowSourceTest() { this = "untrustedflowsource" }

  override string getARelevantTag() { result = "untrustedflowsource" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "untrustedflowsource" and
    value = element and
    exists(UntrustedFlowSource src | value = "\"" + src.toString() + "\"" |
      src.hasLocationInfo(file, line, _, _, _)
    )
  }
}

class HeaderWriteTest extends InlineExpectationsTest {
  HeaderWriteTest() { this = "headerwrite" }

  override string getARelevantTag() { result = "headerwrite" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "headerwrite" and
    exists(HTTP::HeaderWrite hw, string name, string val | element = hw.toString() |
      hw.definesHeader(name, val) and
      value = name + ":" + val and
      hw.hasLocationInfo(file, line, _, _, _)
    )
  }
}

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
