/**
 * Inline flow tests for JavaScript.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

private import semmle.javascript.internal.unified.minimal.minimal
private import semmle.javascript.internal.unified.minimal.Locations
private import codeql.dataflow.test.InlineFlowTest
private import semmle.javascript.internal.unified.JSUnified
private import semmle.javascript.frameworks.data.internal.ApiGraphModelsExtensions as ApiGraphModelsExtensions
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<Location, DataFlowInput> {
  import utils.test.InlineFlowTestUnifiedUtil

  bindingset[src, sink]
  string getArgString(DataFlow2::Node src, DataFlow2::Node sink) {
    (if exists(getSourceArgString(src)) then result = getSourceArgString(src) else result = "") and
    exists(sink)
  }

  predicate interpretModelForTest = ApiGraphModelsExtensions::interpretModelForTest/2;
}

import InlineFlowTestMake<Location, DataFlowInput, TaintTrackingInput, Impl, FlowTestImpl>
