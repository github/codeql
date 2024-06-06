import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineExpectationsTest
import semmle.go.security.IncorrectIntegerConversionLib

module TestIncorrectIntegerConversion implements TestSig {
  string getARelevantTag() { result = "hasValueFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = "\"" + sink.toString() + "\""
    )
  }
}

import MakeTest<TestIncorrectIntegerConversion>
