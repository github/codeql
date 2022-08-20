import go
import TestUtilities.InlineExpectationsTest

class TaintFunctionModelTest extends InlineExpectationsTest {
  TaintFunctionModelTest() { this = "TaintFunctionModelTest" }

  override string getARelevantTag() { result = "ttfnmodelstep" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "ttfnmodelstep" and
    exists(TaintTracking::FunctionModel model, DataFlow::CallNode call | call = model.getACall() |
      call.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = call.toString() and
      value = "\"" + model.getAnInputNode(call) + " -> " + model.getAnOutputNode(call) + "\""
    )
  }
}

class MarshalerTest extends InlineExpectationsTest {
  MarshalerTest() { this = "MarshalerTest" }

  override string getARelevantTag() { result = "marshaler" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "marshaler" and
    exists(MarshalingFunction m, DataFlow::CallNode call | call = m.getACall() |
      call.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = call.toString() and
      value =
        "\"" + m.getFormat() + ": " + m.getAnInput().getNode(call) + " -> " +
          m.getOutput().getNode(call) + "\""
    )
  }
}

class UnmarshalerTest extends InlineExpectationsTest {
  UnmarshalerTest() { this = "UnmarshalerTest" }

  override string getARelevantTag() { result = "unmarshaler" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "unmarshaler" and
    exists(UnmarshalingFunction m, DataFlow::CallNode call | call = m.getACall() |
      call.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = call.toString() and
      value =
        "\"" + m.getFormat() + ": " + m.getAnInput().getNode(call) + " -> " +
          m.getOutput().getNode(call) + "\""
    )
  }
}
