/** Provides taint-tracking configurations to reason about arithmetic with unvalidated user input. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ArithmeticCommon

/** A taint-tracking configuration to reason about overflow from unvalidated user input. */
module RemoteUserInputOverflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/** A taint-tracking configuration to reason about underflow from unvalidated user input. */
module RemoteUserInputUnderflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/** Taint-tracking flow for overflow from unvalidated user input. */
module RemoteUserInputOverflow = TaintTracking::Global<RemoteUserInputOverflowConfig>;

/** Taint-tracking flow for underflow from unvalidated user input. */
module RemoteUserInputUnderflow = TaintTracking::Global<RemoteUserInputUnderflowConfig>;
