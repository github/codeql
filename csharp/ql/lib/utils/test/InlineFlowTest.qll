/**
 * Inline flow tests for CSharp.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import csharp
private import codeql.dataflow.test.InlineFlowTest
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<Location, CsharpDataFlow> {
  predicate defaultSource(DataFlow::Node source) {
    source.asExpr().(MethodCall).getTarget().getUndecoratedName() = ["Source", "Taint"]
  }

  predicate defaultSink(DataFlow::Node sink) {
    exists(MethodCall mc | mc.getTarget().hasUndecoratedName("Sink") |
      sink.asExpr() = mc.getAnArgument()
    )
  }

  private string getSourceArgString(DataFlow::Node src) {
    defaultSource(src) and
    src.asExpr().(MethodCall).getAnArgument().getValue() = result
  }

  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    (
      result = getSourceArgString(src)
      or
      not exists(getSourceArgString(src)) and result = "line:" + src.getLocation().getStartLine()
    ) and
    exists(sink)
  }

  predicate interpretModelForTest = ExternalFlow::interpretModelForTest/2;
}

import InlineFlowTestMake<Location, CsharpDataFlow, CsharpTaintTracking, Impl, FlowTestImpl>
