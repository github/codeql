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
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 29 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@36:8:36:10), Column 5 does not select a source or sink originating from the flow call on line 29 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@38:3:38:18)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 29 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@36:8:36:10), Column 5 does not select a source or sink originating from the flow call on line 29 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@38:3:38:18)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 29 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@36:8:36:10), Column 5 does not select a source or sink originating from the flow call on line 29 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@38:3:38:18)
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
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 33 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@36:8:36:10), Column 5 does not select a source or sink originating from the flow call on line 33 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@38:3:38:18)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 33 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@36:8:36:10), Column 5 does not select a source or sink originating from the flow call on line 33 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@38:3:38:18)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 33 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@36:8:36:10), Column 5 does not select a source or sink originating from the flow call on line 33 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-190/ArithmeticUncontrolled.ql@38:3:38:18)
  }
}

/** Taint-tracking flow to reason about underflow from arithmetic with uncontrolled values. */
module ArithmeticUncontrolledUnderflowFlow =
  TaintTracking::Global<ArithmeticUncontrolledUnderflowConfig>;
