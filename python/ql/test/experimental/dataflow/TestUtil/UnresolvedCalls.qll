import python
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.ApiGraphs
import TestUtilities.InlineExpectationsTest

class UnresolvedCallExpectations extends InlineExpectationsTest {
  UnresolvedCallExpectations() { this = "UnresolvedCallExpectations" }

  override string getARelevantTag() { result = "unresolved_call" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(CallNode call |
      not exists(DataFlowPrivate::DataFlowCall dfc | dfc.getNode() = call) and
      not call = API::builtin(_).getACall().asCfgNode() and
      location = call.getLocation() and
      tag = "unresolved_call" and
      value = prettyExpr(call.getNode()) and
      element = call.toString()
    )
  }
}
