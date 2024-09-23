/**
 * Inline flow tests for Powershell.
 * See `shared/util/codeql/dataflow/test/InlineFlowTest.qll`
 */

import powershell
private import codeql.dataflow.test.InlineFlowTest
private import semmle.code.powershell.dataflow.internal.DataFlowImplSpecific
private import semmle.code.powershell.dataflow.internal.TaintTrackingImplSpecific
private import internal.InlineExpectationsTestImpl

private module FlowTestImpl implements InputSig<Location, PowershellDataFlow> {
  import TestUtilities.InlineFlowTestUtil

  bindingset[src, sink]
  string getArgString(DataFlow::Node src, DataFlow::Node sink) {
    (if exists(getSourceArgString(src)) then result = getSourceArgString(src) else result = "") and
    exists(sink)
  }

  predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) { none() }
}

import InlineFlowTestMake<Location, PowershellDataFlow, PowershellTaintTracking, Impl, FlowTestImpl>
