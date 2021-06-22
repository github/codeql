import python
import semmle.python.dataflow.new.DataFlow
import experimental.dataflow.TestUtil.PrintNode

query predicate conjunctive_lookup(
  DataFlow::MethodCallNode methCall, string call, string object, string methodName
) {
  call = prettyNode(methCall) and
  object = prettyNode(methCall.getObject()) and
  methodName = methCall.getMethodName()
}

query predicate calls_lookup(
  DataFlow::MethodCallNode methCall, string call, string object, string methodName
) {
  call = prettyNode(methCall) and
  exists(DataFlow::Node o | methCall.calls(o, methodName) and object = prettyNode(o))
}
