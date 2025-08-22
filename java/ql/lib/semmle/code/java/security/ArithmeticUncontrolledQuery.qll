/** Provides taint-tracking configuration to reason about arithmetic with uncontrolled values. */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.RandomQuery
private import semmle.code.java.security.SecurityTests
private import semmle.code.java.security.ArithmeticCommon

private class TaintSource extends DataFlow::ExprNode {
  TaintSource() {
    exists(RandomDataSource m | not m.resultMayBeBounded() | m.getOutput() = this.getExpr())
  }
}

/** A taint-tracking configuration to reason about overflow from arithmetic with uncontrolled values. */
module ArithmeticUncontrolledOverflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof TaintSource }

  predicate isSink(DataFlow::Node sink) { overflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { overflowBarrier(n) }

  predicate observeDiffInformedIncrementalMode() {
    any() // merged with ArithmeticUncontrolledUnderflow in ArithmeticUncontrolled.ql
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(ArithExpr exp | result = exp.getLocation() | overflowSink(exp, sink.asExpr()))
  }
}

/** Taint-tracking flow to reason about overflow from arithmetic with uncontrolled values. */
module ArithmeticUncontrolledOverflowFlow =
  TaintTracking::Global<ArithmeticUncontrolledOverflowConfig>;

/** A taint-tracking configuration to reason about underflow from arithmetic with uncontrolled values. */
module ArithmeticUncontrolledUnderflowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof TaintSource }

  predicate isSink(DataFlow::Node sink) { underflowSink(_, sink.asExpr()) }

  predicate isBarrier(DataFlow::Node n) { underflowBarrier(n) }

  predicate observeDiffInformedIncrementalMode() {
    any() // merged with ArithmeticUncontrolledOverflow in ArithmeticUncontrolled.ql
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(ArithExpr exp | result = exp.getLocation() | underflowSink(exp, sink.asExpr()))
  }
}

/** Taint-tracking flow to reason about underflow from arithmetic with uncontrolled values. */
module ArithmeticUncontrolledUnderflowFlow =
  TaintTracking::Global<ArithmeticUncontrolledUnderflowConfig>;
