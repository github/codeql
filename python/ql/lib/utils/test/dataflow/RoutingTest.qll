import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

/**
 * A routing test is designed to test that values are routed to the
 * correct arguments of the correct functions. It is assumed that
 * the functions tested sink their arguments sequentially, that is
 * `SINK1(arg1)`, etc.
 */
signature module RoutingTestSig {
  class Argument;

  string flowTag(Argument arg);

  predicate relevantFlow(DataFlow::Node fromNode, DataFlow::Node toNode, Argument arg);
}

module MakeTestSig<RoutingTestSig Impl> implements TestSig {
  string getARelevantTag() { result in ["func", Impl::flowTag(_)] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node fromNode, DataFlow::Node toNode, Impl::Argument arg |
      Impl::relevantFlow(fromNode, toNode, arg)
    |
      location = fromNode.getLocation() and
      element = fromNode.toString() and
      (
        tag = Impl::flowTag(arg) and
        if "\"" + tag + "\"" = fromValue(fromNode) then value = "" else value = fromValue(fromNode)
        or
        // only have result for `func` tag if the function where `arg<n>` is used, is
        // different from the function name of the call where `arg<n>` was specified as
        // an argument
        tag = "func" and
        value = toFunc(toNode) and
        not value = fromFunc(fromNode)
      )
    )
  }
}

pragma[inline]
private string fromValue(DataFlow::Node fromNode) {
  result = "\"" + prettyNode(fromNode).replaceAll("\"", "'") + "\""
}

pragma[inline]
private string fromFunc(DataFlow::ArgumentNode fromNode) {
  result = fromNode.getCall().getNode().(CallNode).getFunction().getNode().(Name).getId()
}

pragma[inline]
private string toFunc(DataFlow::Node toNode) {
  result = toNode.getEnclosingCallable().getQualifiedName()
}
