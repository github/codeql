import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineExpectationsTest

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

import MakeTest<LoggerTest>
