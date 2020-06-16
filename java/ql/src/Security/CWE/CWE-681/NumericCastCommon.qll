import java
import semmle.code.java.arithmetic.Overflow
import semmle.code.java.dataflow.SSA
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.RangeAnalysis

class NumericNarrowingCastExpr extends CastExpr {
  NumericNarrowingCastExpr() {
    exists(NumericType sourceType, NumericType targetType |
      sourceType = getExpr().getType() and targetType = getType()
    |
      not targetType.(NumType).widerThanOrEqualTo(sourceType.(NumType))
    )
  }
}

class RightShiftOp extends Expr {
  RightShiftOp() {
    this instanceof RShiftExpr or
    this instanceof URShiftExpr or
    this instanceof AssignRShiftExpr or
    this instanceof AssignURShiftExpr
  }

  private Expr getLhs() {
    this.(BinaryExpr).getLeftOperand() = result or
    this.(Assignment).getDest() = result
  }

  Variable getShiftedVariable() {
    getLhs() = result.getAnAccess() or
    getLhs().(AndBitwiseExpr).getAnOperand() = result.getAnAccess()
  }
}

predicate boundedRead(RValue read) {
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

predicate castCheck(RValue read) {
  exists(EqualityTest eq, CastExpr cast |
    cast.getExpr() = read and
    eq.hasOperands(cast, read.getVariable().getAnAccess())
  )
}

class SmallType extends Type {
  SmallType() {
    this instanceof BooleanType or
    this.(PrimitiveType).hasName("byte") or
    this.(BoxedType).getPrimitiveType().hasName("byte")
  }
}

predicate smallExpr(Expr e) {
  exists(int low, int high |
    bounded(e, any(ZeroBound zb), low, false, _) and
    bounded(e, any(ZeroBound zb), high, true, _) and
    high - low < 256
  )
}
