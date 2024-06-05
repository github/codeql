import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineExpectationsTest

predicate isYamlFunction(Function f) {
  f.hasQualifiedName(package("gopkg.in/yaml", ""), _)
  or
  f.(Method).hasQualifiedName(package("gopkg.in/yaml", ""), _, _)
}

DataFlow::CallNode getAYamlCall() {
  isYamlFunction(result.getACalleeIncludingExternals().asFunction())
}

predicate isSourceSinkPair(DataFlow::Node inNode, DataFlow::Node outNode) {
  exists(DataFlow::CallNode cn | cn = getAYamlCall() |
    inNode = [cn.getAnArgument(), cn.getReceiver()] and
    (
      outNode.(DataFlow::PostUpdateNode).getPreUpdateNode() = [cn.getAnArgument(), cn.getReceiver()]
      or
      outNode = cn.getAResult()
    )
  )
}

module TaintTransitsFunctionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { isSourceSinkPair(n, _) }

  predicate isSink(DataFlow::Node n) { isSourceSinkPair(_, n) }
}

module TaintTransitsFunctionFlow = TaintTracking::Global<TaintTransitsFunctionConfig>;

module TaintFunctionModelTest implements TestSig {
  string getARelevantTag() { result = "ttfnmodelstep" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "ttfnmodelstep" and
    (
      exists(TaintTracking::FunctionModel model, DataFlow::CallNode call | call = model.getACall() |
        call.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = call.toString() and
        value = "\"" + model.getAnInputNode(call) + " -> " + model.getAnOutputNode(call) + "\""
      )
      or
      exists(DataFlow::Node arg, DataFlow::Node output |
        TaintTransitsFunctionFlow::flow(arg, output) and
        isSourceSinkPair(arg, output) and
        arg.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = arg.toString() and
        value = "\"" + arg + " -> " + output + "\""
      )
    )
  }
}

module MarshalerTest implements TestSig {
  string getARelevantTag() { result = "marshaler" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

module UnmarshalerTest implements TestSig {
  string getARelevantTag() { result = "unmarshaler" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<MergeTests3<TaintFunctionModelTest, MarshalerTest, UnmarshalerTest>>
