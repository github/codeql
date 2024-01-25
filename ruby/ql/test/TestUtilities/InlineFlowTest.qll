/**
 * Inline flow tests for Ruby.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import ruby
private import codeql.dataflow.test.InlineFlowTest
private import codeql.ruby.dataflow.internal.DataFlowImplSpecific
private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<RubyDataFlow> {
  import TestUtilities.InlineFlowTestUtil

  bindingset[src, sink]
  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    (if exists(getSourceArgString(src)) then result = getSourceArgString(src) else result = "") and
    exists(sink)
  }
}

import InlineFlowTestMake<RubyDataFlow, RubyTaintTracking, Impl, FlowTestImpl>
