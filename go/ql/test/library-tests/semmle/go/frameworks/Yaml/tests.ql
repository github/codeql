import go
import TestUtilities.InlineExpectationsTest

predicate isYamlFunction(Function f) {
  f.hasQualifiedName(package("gopkg.in/yaml", ""), _)
  or
  f.(Method).hasQualifiedName(package("gopkg.in/yaml", ""), _, _)
}

DataFlow::CallNode getAYamlCall() {
  isYamlFunction(result.getACalleeIncludingExternals().asFunction())
}

class TaintTransitsFunctionConfig extends TaintTracking::Configuration {
  TaintTransitsFunctionConfig() { this = "TaintTransitsFunctionConfig" }

  predicate isSourceSinkPair(DataFlow::Node inNode, DataFlow::Node outNode) {
    exists(DataFlow::CallNode cn | cn = getAYamlCall() |
      inNode = [cn.getAnArgument(), cn.getReceiver()] and
      (
        outNode.(DataFlow::PostUpdateNode).getPreUpdateNode() =
          [cn.getAnArgument(), cn.getReceiver()]
        or
        outNode = cn.getAResult()
      )
    )
  }

  override predicate isSource(DataFlow::Node n) { this.isSourceSinkPair(n, _) }

  override predicate isSink(DataFlow::Node n) { this.isSourceSinkPair(_, n) }
}

class TaintFunctionModelTest extends InlineExpectationsTest {
  TaintFunctionModelTest() { this = "TaintFunctionModelTest" }

  override string getARelevantTag() { result = "ttfnmodelstep" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "ttfnmodelstep" and
    (
      exists(TaintTracking::FunctionModel model, DataFlow::CallNode call | call = model.getACall() |
        call.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = call.toString() and
        value = "\"" + model.getAnInputNode(call) + " -> " + model.getAnOutputNode(call) + "\""
      )
      or
      exists(TaintTransitsFunctionConfig config, DataFlow::Node arg, DataFlow::Node output |
        config.hasFlow(arg, output) and
        config.isSourceSinkPair(arg, output) and
        arg.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = arg.toString() and
        value = "\"" + arg + " -> " + output + "\""
      )
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
