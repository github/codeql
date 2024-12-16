/**
 * Inline flow tests for Ruby.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import ruby
private import codeql.Locations
private import codeql.dataflow.test.InlineFlowTest
private import codeql.ruby.dataflow.internal.DataFlowImplSpecific
private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific
private import codeql.ruby.frameworks.data.internal.ApiGraphModelsExtensions as ApiGraphModelsExtensions
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<Location, RubyDataFlow> {
  import utils.test.InlineFlowTestUtil

  bindingset[src, sink]
  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    (if exists(getSourceArgString(src)) then result = getSourceArgString(src) else result = "") and
    exists(sink)
  }

  predicate interpretModelForTest = ApiGraphModelsExtensions::interpretModelForTest/2;
}

import InlineFlowTestMake<Location, RubyDataFlow, RubyTaintTracking, Impl, FlowTestImpl>
