import go
import TestUtilities.InlineExpectationsTest

class UntrustedFlowSourceTest extends InlineExpectationsTest {
  UntrustedFlowSourceTest() { this = "untrustedflowsource" }

  override string getARelevantTag() { result = "untrustedflowsource" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "untrustedflowsource" and
    value = element and
    exists(UntrustedFlowSource src | value = "\"" + src.toString() + "\"" |
      src.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

class HeaderWriteTest extends InlineExpectationsTest {
  HeaderWriteTest() { this = "headerwrite" }

  override string getARelevantTag() { result = "headerwrite" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "headerwrite" and
    exists(Http::HeaderWrite hw, string name, string val | element = hw.toString() |
      hw.definesHeader(name, val) and
      value = name + ":" + val and
      hw.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

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

class Config extends TaintTracking::Configuration {
  Config() { this = "goproxy config" }

  override predicate isSource(DataFlow::Node n) {
    n = any(DataFlow::CallNode c | c.getCalleeName().matches("tainted%")).getResult()
  }

  override predicate isSink(DataFlow::Node n) {
    n = any(DataFlow::CallNode cn | cn.getTarget().getName() = "sink").getAnArgument()
  }
}

class TaintFlow extends InlineExpectationsTest {
  TaintFlow() { this = "goproxy flow" }

  override string getARelevantTag() { result = "taintflow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "taintflow" and
    value = "" and
    element = "" and
    exists(Config c, DataFlow::Node toNode |
      toNode
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      c.hasFlowTo(toNode)
    )
  }
}
