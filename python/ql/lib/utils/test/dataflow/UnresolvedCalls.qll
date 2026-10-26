import python
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.ApiGraphs
import utils.test.InlineExpectationsTest

signature module UnresolvedCallExpectationsSig {
  predicate unresolvedCall(CallNode call);
}

module DefaultUnresolvedCallExpectations implements UnresolvedCallExpectationsSig {
  predicate unresolvedCall(CallNode call) {
    not exists(DataFlowPrivate::DataFlowCall dfc |
      exists(dfc.getCallable()) and dfc.getNode() = call
    ) and
    not DataFlowPrivate::resolveClassCall(call, _) and
    not call = API::builtin(_).getACall().asCfgNode()
  }
}

module MakeUnresolvedCallExpectations<UnresolvedCallExpectationsSig Impl> {
  private module UnresolvedCallExpectations implements TestSig {
    string getARelevantTag() { result = "unresolved_call" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(location.getFile().getRelativePath()) and
      exists(CallNode call | Impl::unresolvedCall(call) |
        location = call.getLocation() and
        tag = "unresolved_call" and
        value = prettyExpr(call.getNode()) and
        element = call.toString()
      )
    }
  }

  import MakeTest<UnresolvedCallExpectations>
}
