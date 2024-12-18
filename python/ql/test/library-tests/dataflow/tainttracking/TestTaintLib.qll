import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.PrintNode

module TestTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // Standard sources
    source.(DataFlow::CfgNode).getNode().(NameNode).getId() in [
        "TAINTED_STRING", "TAINTED_BYTES", "TAINTED_LIST", "TAINTED_DICT"
      ]
    or
    // User defined sources
    exists(CallNode call |
      call.getFunction().(NameNode).getId() = "taint" and
      source.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() in ["ensure_tainted", "ensure_not_tainted"] and
      sink.(DataFlow::CfgNode).getNode() = call.getAnArg()
    )
  }
}

module TestTaintTrackingFlow = DataFlow::Global<TestTaintTrackingConfig>;

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
        TestTaintTrackingFlow::flowTo(any(DataFlow::Node n |
            n.(DataFlow::CfgNode).getNode() = arg.getAFlowNode()
          ))
      then has_taint = true
      else has_taint = false
    ) and
    (if expected_taint = has_taint then test_res = "ok  " else test_res = "fail") and
    // select
    arg_location = arg.getLocation().toString() and
    test_res = test_res and
    scope_name = call.getScope().getName() and
    repr = prettyExpr(arg)
  )
}
