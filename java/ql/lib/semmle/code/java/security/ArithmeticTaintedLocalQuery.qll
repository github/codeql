/** Provides taint-tracking configurations to reason about arithmetic using local-user-controlled data. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ArithmeticCommon

/**
 * DEPRECATED: Use `ArithmeticOverflowConfig` instead.
 *
 * A taint-tracking configuration to reason about arithmetic overflow using local-user-controlled data.
 */
deprecated module ArithmeticTaintedLocalOverflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * DEPRECATED: Use `ArithmeticOverflow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for arithmetic overflow using local-user-controlled data.
 */
deprecated module ArithmeticTaintedLocalOverflowFlow =
  TaintTracking::Global<ArithmeticTaintedLocalOverflowConfig>;

/**
 * A taint-tracking configuration to reason about arithmetic underflow using local-user-controlled data.
 */
deprecated module ArithmeticTaintedLocalUnderflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * DEPRECATED: Use `ArithmeticUnderflow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for arithmetic underflow using local-user-controlled data.
 */
deprecated module ArithmeticTaintedLocalUnderflowFlow =
  TaintTracking::Global<ArithmeticTaintedLocalUnderflowConfig>;
