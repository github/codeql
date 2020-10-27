import semmle.code.java.dataflow.RangeAnalysis
import semmle.code.java.dataflow.FlowSteps
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

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

abstract class AllocatingCallable extends Callable {
  abstract int getParam();
}

class AtomicArrayConstructor extends AllocatingCallable, Constructor {
  AtomicArrayConstructor() {
    this
        .getDeclaringType()
        .hasQualifiedName("java.util.concurrent.atomic",
          ["AtomicIntArray", "AtomicLongArray", "AtomicReferenceArray"]) and
    this.getParameterType(0) instanceof IntegralType
  }

  override int getParam() { result = 0 }
}

class ListConstructor extends AllocatingCallable, Constructor {
  ListConstructor() {
    this.getDeclaringType().hasQualifiedName("java.util", ["ArrayList", "Vector"]) and
    this.getParameterType(0) instanceof IntegralType
  }

  override int getParam() { result = 0 }
}

class ReadMethod extends TaintPreservingCallable {
  ReadMethod() {
    this.getDeclaringType().hasQualifiedName("java.io", "ObjectInputStream") and
    this.getName().matches("read%")
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

class ArithmeticStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node src, DataFlow::Node sink) {
    exists(BinaryExpr binex | sink.asExpr() = binex and src.asExpr() = binex.getAnOperand() |
      binex instanceof AddExpr
      or
      binex instanceof MulExpr
      or
      binex instanceof SubExpr
      or
      src.asExpr() = binex.getLeftOperand() and
      (
        binex instanceof DivExpr
        or
        binex instanceof LShiftExpr
        or
        binex instanceof RShiftExpr
        or
        binex instanceof URShiftExpr
      )
    )
  }
}

predicate hasUpperBound(Expr e) { bounded(e, any(ZeroBound z), _, true, _) }
