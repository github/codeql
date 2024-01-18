import TestUtilities.dataflow.FlowTestCommon
import semmle.code.cpp.security.FlowSources

/**
 * Models-as-data source models for this test.
 */
private class TestSources extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;localMadSource;;;ReturnValue;remote",
        ";;false;remoteMadSource;;;ReturnValue;local",
        ";;false;localMadSourceHasBody;;;ReturnValue;remote",
        // TODO: remoteMadSourceIndirect
        ";;false;remoteMadSourceArg0;;;Argument[0];remote",
        ";;false;remoteMadSourceArg1;;;Argument[1];remote", ";;false;remoteMadSourceVar;;;;remote",
        ";;false;remoteMadSourceParam0;;;Parameter[0];remote",
        ";MyClass;true;memberRemoteMadSource;;;ReturnValue;remote",
        ";MyClass;true;memberRemoteMadSourceArg0;;;Argument[0];remote",
        ";MyClass;true;memberRemoteMadSourceVar;;;;remote",
        ";MyClass;true;subtypeRemoteMadSource1;;;ReturnValue;remote",
        ";MyClass;false;subtypeNonSource;;;ReturnValue;remote", // only a source if defined in MyClass
        ";MyDerivedClass;false;subtypeRemoteMadSource2;;;ReturnValue;remote",
      ]
  }
}

/**
 * Models-as-data sink models for this test.
 */
private class TestSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;madSinkArg0;;;Argument[0];test-sink",
        ";;false;madSinkArg1;;;Argument[1];test-sink",
        ";;false;madSinkArg12;;;Argument[1..2];test-sink",
        ";;false;madSinkArg13;;;Argument[1,3];test-sink",
        // TODO: madSinkIndirectArg0
        ";;false;madSinkVar;;;;test-sink", ";;false;madSinkParam0;;;Parameter[0];remote",
        ";MyClass;true;memberMadSinkArg0;;;Argument[0];test-sink",
        ";MyClass;true;memberMadSinkVar;;;;test-sink",
      ]
  }
}

/**
 * Models-as-data summary models for this test.
 */
private class TestSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;madArg0ToReturn;;;Argument[0];ReturnValue;taint",
        ";;false;madArg0ToReturnValueFlow;;;Argument[0];ReturnValue;value",
        // TODO: madArg0IndirectToReturn
        ";;false;madArg0ToArg1;;;Argument[0];Argument[1];taint",
        // TODO: madArg0IndirectToArg1
        ";;false;madArg0FieldToReturn;;;Argument[0].value;ReturnValue;taint",
        // TODO: madArg0IndirectFieldToReturn
        ";;false;madArg0ToReturnField;;;Argument[0];ReturnValue.value;taint",
        ";MyClass;true;madArg0ToSelf;;;Argument[0];Argument[-1];taint",
        ";MyClass;true;madSelfToReturn;;;Argument[-1];ReturnValue;taint",
        ";MyClass;true;madArg0ToField;;;Argument[0];Argument[-1].val;taint",
        ";MyClass;true;madFieldToReturn;;;Argument[-1].val;ReturnValue;taint",
      ]
  }
}

module IRTest {
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  /** Common data flow configuration to be used by tests. */
  module TestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof FlowSource
      or
      source.asExpr().(FunctionCall).getTarget().getName() = ["source", "source2"]
    }

    predicate isSink(DataFlow::Node sink) {
      sinkNode(sink, "test-sink")
      or
      exists(FunctionCall call |
        call.getTarget().getName() = "sink" and
        [sink.asExpr(), sink.asIndirectExpr()] = call.getAnArgument()
      )
    }
  }

  module IRFlow = TaintTracking::Global<TestAllocationConfig>;
}

import MakeTest<IRFlowTest<IRTest::IRFlow>>
