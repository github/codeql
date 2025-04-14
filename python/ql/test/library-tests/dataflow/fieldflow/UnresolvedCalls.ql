import python
import utils.test.dataflow.UnresolvedCalls
private import semmle.python.dataflow.new.DataFlow

module IgnoreDictMethod implements UnresolvedCallExpectationsSig {
  predicate unresolvedCall(CallNode call) {
    DefaultUnresolvedCallExpectations::unresolvedCall(call) and
    not any(DataFlow::MethodCallNode methodCall |
      methodCall.getMethodName() in ["get", "setdefault"]
    ).asCfgNode() = call
  }
}

import MakeUnresolvedCallExpectations<IgnoreDictMethod>
