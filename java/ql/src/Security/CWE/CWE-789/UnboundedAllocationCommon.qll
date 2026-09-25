/**
 * Common definitions for the unbounded allocation queries.
 */

import semmle.code.java.dataflow.RangeAnalysis
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

/** A sink where memory is allocated. */
class AllocationSink extends DataFlow::Node {
  AllocationSink() {
    this.asExpr() = any(ArrayCreationExpr a).getADimension()
    or
    exists(Call c, int i |
      c.getArgument(i) = this.asExpr() and
      c.getCallee().(AllocatingCallable).getParam() = i
    )
  }
}

/** A callable that allocates memory. */
abstract class AllocatingCallable extends Callable {
  /** Returns the parameter index controlling the size of the allocated memory. */
  abstract int getParam();
}

private class AtomicArrayConstructor extends AllocatingCallable, Constructor {
  AtomicArrayConstructor() {
    this
        .getDeclaringType()
        .hasQualifiedName("java.util.concurrent.atomic",
          ["AtomicIntegerArray", "AtomicLongArray", "AtomicReferenceArray"]) and
    this.getParameterType(0) instanceof IntegralType
  }

  override int getParam() { result = 0 }
}

private class ListConstructor extends AllocatingCallable, Constructor {
  ListConstructor() {
    this.getDeclaringType().hasQualifiedName("java.util", ["ArrayList", "Vector"]) and
    this.getParameterType(0) instanceof IntegralType
  }

  override int getParam() { result = 0 }
}

private class ArithmeticStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node src, DataFlow::Node sink) {
    exists(BinaryExpr binex | sink.asExpr() = binex and src.asExpr() = binex.getAnOperand() |
      binex instanceof AddExpr
      or
      binex instanceof MulExpr
      or
      binex instanceof SubExpr
      or
      binex instanceof LShiftExpr
      or
      src.asExpr() = binex.getLeftOperand() and
      (
        binex instanceof DivExpr
        or
        binex instanceof RShiftExpr
        or
        binex instanceof URShiftExpr
      )
    )
  }
}

/** Holds if `e` has a known upper bound. */
predicate hasUpperBound(Expr e) { bounded(e, any(ZeroBound z), _, true, _) }
