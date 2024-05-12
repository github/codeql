/** Provides taint-tracking configurations to reason about arithmetic using local-user-controlled data. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.ArithmeticCommon

/**
 * A taint-tracking configuration to reason about arithmetic overflow using local-user-controlled data.
 */
module ArithmeticTaintedLocalOverflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * Taint-tracking flow for arithmetic overflow using local-user-controlled data.
 */
module ArithmeticTaintedLocalOverflowFlow =
  TaintTracking::Global<ArithmeticTaintedLocalOverflowConfig>;

/**
 * A taint-tracking configuration to reason about arithmetic underflow using local-user-controlled data.
 */
module ArithmeticTaintedLocalUnderflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * Taint-tracking flow for arithmetic underflow using local-user-controlled data.
 */
module ArithmeticTaintedLocalUnderflowFlow =
  TaintTracking::Global<ArithmeticTaintedLocalUnderflowConfig>;
