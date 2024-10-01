/** Provides classes to reason about possible truncation from casting of a user-provided value. */

import java
private import semmle.code.java.arithmetic.Overflow
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.RangeAnalysis
private import semmle.code.java.dataflow.FlowSources

/**
 * A `CastExpr` that is a narrowing cast.
 */
class NumericNarrowingCastExpr extends CastExpr {
  NumericNarrowingCastExpr() {
    exists(NumericType sourceType, NumericType targetType |
      sourceType = this.getExpr().getType() and targetType = this.getType()
    |
      not targetType.(NumType).widerThanOrEqualTo(sourceType)
    )
  }
}

/**
 * An expression that performs a right shift operation.
 */
class RightShiftOp extends Expr {
  RightShiftOp() {
    this instanceof RightShiftExpr or
    this instanceof UnsignedRightShiftExpr or
    this instanceof AssignRightShiftExpr or
    this instanceof AssignUnsignedRightShiftExpr
  }

  private Expr getLhs() {
    this.(BinaryExpr).getLeftOperand() = result or
    this.(Assignment).getDest() = result
  }

  /**
   * Gets the variable that is shifted.
   */
  Variable getShiftedVariable() {
    this.getLhs() = result.getAnAccess() or
    this.getLhs().(AndBitwiseExpr).getAnOperand() = result.getAnAccess()
  }
}

private predicate boundedRead(VarRead read) {
  exists(SsaVariable v, ConditionBlock cb, ComparisonExpr comp, boolean testIsTrue |
    read = v.getAUse() and
    cb.controls(read.getBasicBlock(), testIsTrue) and
    cb.getCondition() = comp
  |
    comp.getLesserOperand() = v.getAUse() and testIsTrue = true
    or
    comp.getGreaterOperand() = v.getAUse() and testIsTrue = false
  )
}

private predicate castCheck(VarRead read) {
  exists(EqualityTest eq, CastExpr cast |
    cast.getExpr() = read and
    eq.hasOperands(cast, read.getVariable().getAnAccess())
  )
}

private class SmallType extends Type {
  SmallType() {
    this instanceof BooleanType or
    this.(PrimitiveType).hasName("byte") or
    this.(BoxedType).getPrimitiveType().hasName("byte")
  }
}

private predicate smallExpr(Expr e) {
  exists(int low, int high |
    bounded(e, any(ZeroBound zb), low, false, _) and
    bounded(e, any(ZeroBound zb), high, true, _) and
    high - low < 256
  )
}

/**
 * A taint-tracking configuration for reasoning about user input that is used in a
 * numeric cast.
 */
module NumericCastFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr() and
    sink.asExpr() instanceof VarAccess
  }

  predicate isBarrier(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod or
    exists(RightShiftOp e | e.getShiftedVariable().getAnAccess() = node.asExpr())
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow for user input that is used in a numeric cast.
 */
module NumericCastFlow = TaintTracking::Global<NumericCastFlowConfig>;

/**
 * A taint-tracking configuration for reasoning about local user input that is
 * used in a numeric cast.
 */
deprecated module NumericCastLocalFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(NumericNarrowingCastExpr cast).getExpr() and
    sink.asExpr() instanceof VarAccess
  }

  predicate isBarrier(DataFlow::Node node) {
    boundedRead(node.asExpr()) or
    castCheck(node.asExpr()) or
    node.getType() instanceof SmallType or
    smallExpr(node.asExpr()) or
    node.getEnclosingCallable() instanceof HashCodeMethod or
    exists(RightShiftOp e | e.getShiftedVariable().getAnAccess() = node.asExpr())
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * DEPRECATED: Use `NumericCastFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for local user input that is used in a numeric cast.
 */
deprecated module NumericCastLocalFlow = TaintTracking::Global<NumericCastLocalFlowConfig>;
