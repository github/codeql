import go
import TestUtilities.InlineExpectationsTest
import semmle.go.security.IncorrectIntegerConversionLib

module TestIncorrectIntegerConversion implements TestSig {
  string getARelevantTag() { result = "hasValueFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node sink, DataFlow::Node sinkConverted |
      Flow::flowTo(sink) and
      sinkConverted = sink.getASuccessor()
    |
      sinkConverted
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sinkConverted.toString() and
      value = "\"" + sinkConverted.toString() + "\""
    )
  }
}

import MakeTest<TestIncorrectIntegerConversion>
