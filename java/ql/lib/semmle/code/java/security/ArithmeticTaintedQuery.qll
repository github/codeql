/** Provides taint-tracking configurations to reason about arithmetic with unvalidated input. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ArithmeticCommon

/** A taint-tracking configuration to reason about overflow from unvalidated input. */
module ArithmeticOverflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * DEPRECATED: Use `ArithmeticOverflowConfig` instead.
 */
deprecated module RemoteUserInputOverflowConfig = ArithmeticOverflowConfig;

/** A taint-tracking configuration to reason about underflow from unvalidated input. */
module ArithmeticUnderflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * DEPRECATED: Use `ArithmeticUnderflowConfig` instead.
 */
deprecated module RemoteUserInputUnderflowConfig = ArithmeticUnderflowConfig;

/** Taint-tracking flow for overflow from unvalidated input. */
module ArithmeticOverflow = TaintTracking::Global<ArithmeticOverflowConfig>;

/**
 * DEPRECATED: Use `ArithmeticOverflow` instead.
 */
deprecated module RemoteUserInputOverflow = ArithmeticOverflow;

/** Taint-tracking flow for underflow from unvalidated input. */
module ArithmeticUnderflow = TaintTracking::Global<ArithmeticUnderflowConfig>;

/**
 * DEPRECATED: Use `ArithmeticUnderflow` instead.
 */
deprecated module RemoteUserInputUnderflow = ArithmeticUnderflow;
