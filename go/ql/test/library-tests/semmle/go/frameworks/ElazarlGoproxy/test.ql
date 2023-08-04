import go
import TestUtilities.InlineExpectationsTest

module UntrustedFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "untrustedflowsource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "untrustedflowsource" and
    value = element and
    exists(UntrustedFlowSource src | value = "\"" + src.toString() + "\"" |
      src.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

module HeaderWriteTest implements TestSig {
  string getARelevantTag() { result = "headerwrite" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "headerwrite" and
    exists(Http::HeaderWrite hw, string name, string val | element = hw.toString() |
      hw.definesHeader(name, val) and
      value = name + ":" + val and
      hw.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

module LoggerTest implements TestSig {
  string getARelevantTag() { result = "logger" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(LoggerCall log |
      log.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = log.toString() and
      value = log.getAMessageComponent().toString() and
      tag = "logger"
    )
  }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) {
    n = any(DataFlow::CallNode c | c.getCalleeName().matches("tainted%")).getResult()
  }

  predicate isSink(DataFlow::Node n) {
    n = any(DataFlow::CallNode cn | cn.getTarget().getName() = "sink").getAnArgument()
  }
}

module Flow = TaintTracking::Global<Config>;

module TaintFlow implements TestSig {
  string getARelevantTag() { result = "taintflow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "taintflow" and
    value = "" and
    element = "" and
    exists(DataFlow::Node toNode |
      toNode
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      Flow::flowTo(toNode)
    )
  }
}

import MakeTest<MergeTests4<UntrustedFlowSourceTest, HeaderWriteTest, LoggerTest, TaintFlow>>
