/**
 * Inline flow tests for Rust.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import rust
private import codeql.dataflow.test.InlineFlowTest
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import internal.InlineExpectationsTestImpl as InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<Location, RustDataFlow> {
  predicate defaultSource(DataFlow::Node source) {
    source.asExpr().(CallExpr).getExpr().toString() = "source"
  }

  predicate defaultSink(DataFlow::Node sink) {
    any(CallExpr call | call = sink.asExpr() and call.getExpr().toString() = "sink")
        .getArgList()
        .getAnArg() = sink.asExpr()
  }

  private string getSourceArgString(DataFlow::Node src) {
    defaultSource(src) and
    result = src.asExpr().(CallExpr).getArgList().getArg(0).toString()
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

  predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) { none() }
}

import InlineFlowTestMake<Location, RustDataFlow, RustTaintTracking, InlineExpectationsTestImpl::Impl, FlowTestImpl>
