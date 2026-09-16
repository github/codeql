/**
 * Inline flow tests for the unified language.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

private import unified
private import codeql.dataflow.test.InlineFlowTest
private import codeql.unified.internal.dataflow.AllDataFlow
private import internal.InlineExpectationsTestImpl as InlineExpectationsTestImpl

private string getCalleeName(CallExpr call) { result = call.getCallee().(Identifier).getValue() }

private module FlowTestImpl implements InputSig<Location, DataFlowInput> {
  predicate defaultSource(DataFlow::Node source) { getCalleeName(source.asExpr()) = "source" }

  predicate defaultSink(DataFlow::Node sink) {
    any(CallExpr call | getCalleeName(call) = "sink").getAnArgument().getValue() = sink.asExpr()
  }

  private string getSourceArgString(DataFlow::Node src) {
    defaultSource(src) and
    result = src.asExpr().(CallExpr).getArgument(0).getValue().getStringValue()
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

import InlineFlowTestMake<Location, DataFlowInput, TaintTrackingInput, InlineExpectationsTestImpl::Impl, FlowTestImpl>
