import python
import semmle.python.dataflow.TaintTracking

class SimpleTest extends TaintKind {
  SimpleTest() { this = "simple.test" }
}

class SimpleSink extends TaintSink {
  override string toString() { result = "Simple sink" }

  SimpleSink() {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "SINK" and
      this = call.getAnArg()
    )
  }

  override predicate sinks(TaintKind taint) { taint instanceof SimpleTest }
}

class SimpleSource extends TaintSource {
  SimpleSource() { this.(NameNode).getId() = "SOURCE" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof SimpleTest }

  override string toString() { result = "simple.source" }
}

predicate visit_call(CallNode call, FunctionObject func) {
  exists(AttrNode attr, ClassObject cls, string name |
    name.matches("visit\\_%") and
    func = cls.lookupAttribute(name) and
    attr.getObject("visit").refersTo(_, cls, _) and
    attr = call.getFunction()
  )
}

/* Test call extensions by tracking taint through visitor methods */
class TestCallReturnExtension extends DataFlowExtension::DataFlowNode {
  TestCallReturnExtension() {
    exists(PyFunctionObject func |
      visit_call(_, func) and
      this = func.getAReturnedNode()
    )
  }

  override ControlFlowNode getAReturnSuccessorNode(CallNode call) {
    exists(PyFunctionObject func |
      visit_call(call, func) and
      this = func.getAReturnedNode() and
      result = call
    )
  }
}

class TestCallParameterExtension extends DataFlowExtension::DataFlowNode {
  TestCallParameterExtension() {
    exists(PyFunctionObject func, CallNode call |
      visit_call(call, func) and
      this = call.getAnArg()
    )
  }

  override ControlFlowNode getACalleeSuccessorNode(CallNode call) {
    exists(PyFunctionObject func |
      visit_call(call, func) and
      exists(int n |
        this = call.getArg(n) and
        result.getNode() = func.getFunction().getArg(n + 1)
      )
    )
  }
}
