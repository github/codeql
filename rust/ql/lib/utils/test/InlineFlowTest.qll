/**
 * Inline flow tests for Rust.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import rust
private import codeql.dataflow.test.InlineFlowTest
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.rust.dataflow.internal.ModelsAsData as MaD
private import internal.InlineExpectationsTestImpl as InlineExpectationsTestImpl

/**
 * Holds if the target expression of `call` is a path and the string
 * representation of the path has `name` as a prefix.
 */
bindingset[name]
private predicate callTargetName(CallExprCfgNode call, string name) {
  call.getFunction().(PathExprCfgNode).toString().matches(name + "%")
}

private module FlowTestImpl implements InputSig<Location, RustDataFlow> {
  predicate defaultSource(DataFlow::Node source) { callTargetName(source.asExpr(), "source") }

  predicate defaultSink(DataFlow::Node sink) {
    any(CallExprCfgNode call | callTargetName(call, "sink")).getArgument(_) = sink.asExpr()
  }

  private string getSourceArgString(DataFlow::Node src) {
    defaultSource(src) and
    result = src.asExpr().(CallExprCfgNode).getArgument(0).toString()
    or
    sourceNode(src, _) and
    exists(CallExprBase call |
      call = src.(Node::FlowSummaryNode).getSourceElement().getCall() and
      result = call.getArgList().getArg(0).toString()
    )
  }

  bindingset[src, sink]
  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    (
      result = getSourceArgString(src)
      or
      not exists(getSourceArgString(src)) and result = ""
    ) and
    exists(sink)
  }

  predicate interpretModelForTest = MaD::interpretModelForTest/2;
}

import InlineFlowTestMake<Location, RustDataFlow, RustTaintTracking, InlineExpectationsTestImpl::Impl, FlowTestImpl>
