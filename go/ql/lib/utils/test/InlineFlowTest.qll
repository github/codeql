/**
 * Inline flow tests for Go.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import go
private import codeql.dataflow.test.InlineFlowTest
private import semmle.go.dataflow.internal.DataFlowImplSpecific
private import semmle.go.dataflow.internal.TaintTrackingImplSpecific
private import semmle.go.dataflow.ExternalFlow as ExternalFlow
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<Location, GoDataFlow> {
  predicate defaultSource(DataFlow::Node source) {
    exists(Function fn | fn.hasQualifiedName(_, ["source", "taint"]) |
      source = fn.getACall().getResult()
    )
  }

  predicate defaultSink(DataFlow::Node sink) {
    exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
  }

  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    exists(src) and
    result = "\"" + sink.toString() + "\""
  }

  predicate interpretModelForTest = ExternalFlow::interpretModelForTest/2;
}

import InlineFlowTestMake<Location, GoDataFlow, GoTaintTracking, Impl, FlowTestImpl>
