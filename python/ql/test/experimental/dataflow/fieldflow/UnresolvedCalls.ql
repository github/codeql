import python
import experimental.dataflow.TestUtil.UnresolvedCalls
private import semmle.python.dataflow.new.DataFlow

class IgnoreDictMethod extends UnresolvedCallExpectations {
  override predicate unresolvedCall(CallNode call) {
    super.unresolvedCall(call) and
    not any(DataFlow::MethodCallNode methodCall |
      methodCall.getMethodName() in ["get", "setdefault"]
    ).asCfgNode() = call
  }
}
