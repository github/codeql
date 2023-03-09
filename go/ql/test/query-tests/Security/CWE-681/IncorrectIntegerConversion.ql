import go
import TestUtilities.InlineExpectationsTest
import semmle.go.security.IncorrectIntegerConversionLib

class TestIncorrectIntegerConversion extends InlineExpectationsTest {
  TestIncorrectIntegerConversion() { this = "TestIncorrectIntegerConversion" }

  override string getARelevantTag() { result = "hasValueFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasValueFlow" and
    exists(DataFlow::Node sink, DataFlow::Node sinkConverted |
      any(ConversionWithoutBoundsCheckConfig config).hasFlowTo(sink) and
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
