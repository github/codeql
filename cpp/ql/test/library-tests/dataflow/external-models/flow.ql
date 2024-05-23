import TestUtilities.dataflow.FlowTestCommon
import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.dataflow.ExternalFlow

module IRTest {
  private import semmle.code.cpp.ir.IR
  private import semmle.code.cpp.ir.dataflow.TaintTracking

  /** Common data flow configuration to be used by tests. */
  module TestAllocationConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      sourceNode(source, _)
    }

    predicate isSink(DataFlow::Node sink) {
      sinkNode(sink, "test-sink")
    }
  }

  module IRFlow = TaintTracking::Global<TestAllocationConfig>;
}

import MakeTest<IRFlowTest<IRTest::IRFlow>>
