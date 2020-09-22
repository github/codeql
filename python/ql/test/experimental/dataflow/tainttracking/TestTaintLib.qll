import python
import experimental.dataflow.TaintTracking
import experimental.dataflow.DataFlow

class TestTaintTrackingConfiguration extends TaintTracking::Configuration {
  TestTaintTrackingConfiguration() { this = "TestTaintTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CfgNode).getNode().(NameNode).getId() in ["TAINTED_STRING", "TAINTED_BYTES",
          "TAINTED_LIST", "TAINTED_DICT"]
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() in ["ensure_tainted", "ensure_not_tainted"] and
      sink.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }
}

private string repr(Expr e) {
  not e instanceof Num and
  not e instanceof StrConst and
  not e instanceof Subscript and
  not e instanceof Call and
  not e instanceof Attribute and
  result = e.toString()
  or
  result = e.(Num).getN()
  or
  result =
    e.(StrConst).getPrefix() + e.(StrConst).getText() +
      e.(StrConst).getPrefix().regexpReplaceAll("[a-zA-Z]+", "")
  or
  result = repr(e.(Subscript).getObject()) + "[" + repr(e.(Subscript).getIndex()) + "]"
  or
  (
    if exists(e.(Call).getAnArg()) or exists(e.(Call).getANamedArg())
    then result = repr(e.(Call).getFunc()) + "(..)"
    else result = repr(e.(Call).getFunc()) + "()"
  )
  or
  result = repr(e.(Attribute).getObject()) + "." + e.(Attribute).getName()
}

query predicate test_taint(string arg_location, string test_res, string scope_name, string repr) {
  exists(Call call, Expr arg, boolean expected_taint, boolean has_taint |
    // only consider files that are extracted as part of the test
    exists(call.getLocation().getFile().getRelativePath()) and
    (
      call.getFunc().(Name).getId() = "ensure_tainted" and
      expected_taint = true
      or
      call.getFunc().(Name).getId() = "ensure_not_tainted" and
      expected_taint = false
    ) and
    arg = call.getAnArg() and
    (
      // TODO: Replace with `hasFlowToExpr` once that is working
      if
        exists(TaintTracking::Configuration c |
          c.hasFlowTo(any(DataFlow::Node n | n.(DataFlow::CfgNode).getNode() = arg.getAFlowNode()))
        )
      then has_taint = true
      else has_taint = false
    ) and
    (if expected_taint = has_taint then test_res = "ok  " else test_res = "fail") and
    // select
    arg_location = arg.getLocation().toString() and
    test_res = test_res and
    scope_name = call.getScope().getName() and
    repr = repr(arg)
  )
}
