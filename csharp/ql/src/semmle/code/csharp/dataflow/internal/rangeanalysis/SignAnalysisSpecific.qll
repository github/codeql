/**
 * Provides C#-specific definitions for use in sign analysis.
 */
module Private {
  private import SsaUtils as SU
  private import csharp as CS
  private import ConstantUtils as CU
  private import semmle.code.csharp.controlflow.Guards as G
  import Impl

  class Guard = G::Guard;

  class ConstantIntegerExpr = CU::ConstantIntegerExpr;

  class SsaVariable = CS::Ssa::Definition;

  class SsaPhiNode = CS::Ssa::PhiNode;

  class VarAccess = CS::AssignableAccess;

  class FieldAccess = CS::FieldAccess;

  class CharacterLiteral = CS::CharLiteral;

  class IntegerLiteral = CS::IntegerLiteral;

  class LongLiteral = CS::LongLiteral;

  class CastExpr = CS::CastExpr;

  class Type = CS::Type;

  class Expr = CS::Expr;

  predicate ssaRead = SU::ssaRead/2;
}

private module Impl {
  private import csharp
  private import SsaUtils
  private import ConstantUtils
  private import semmle.code.csharp.controlflow.Guards
  private import Linq.Helpers
  private import Sign
  private import SignAnalysisCommon
  private import SsaReadPositionCommon
  private import semmle.code.csharp.commons.ComparisonTest

  private class BooleanValue = AbstractValues::BooleanValue;

  float getNonIntegerValue(Expr e) {
    exists(string s |
      s = e.getValue() and
      result = s.toFloat() and
      not exists(s.toInt())
    )
  }

  string getCharValue(Expr e) { result = e.getValue() and e.getType() instanceof CharType }

  predicate containerSizeAccess(Expr e) {
    exists(Property p | p = e.(PropertyAccess).getTarget() |
      propertyOverrides(p, "System.Collections.Generic.IEnumerable<>", "Count") or
      propertyOverrides(p, "System.Collections.ICollection", "Count") or
      propertyOverrides(p, "System.String", "Length") or
      propertyOverrides(p, "System.Array", "Length")
    )
    or
    e instanceof CountCall
  }

  predicate positiveExpression(Expr e) { e instanceof SizeofExpr }

  class NumericOrCharType extends Type {
    NumericOrCharType() {
      this instanceof CharType or
      this instanceof IntegralType or
      this instanceof FloatingPointType or
      this instanceof DecimalType or
      this instanceof Enum or
      this instanceof PointerType // should be similar to unsigned integers
    }
  }

  Sign explicitSsaDefSign(Ssa::ExplicitDefinition v) {
    exists(AssignableDefinition def | def = v.getADefinition() |
      result = exprSign(def.getSource())
      or
      not exists(def.getSource()) and
      not def.getElement() instanceof MutatorOperation
      or
      result = exprSign(def.getElement().(IncrementOperation).getOperand()).inc()
      or
      result = exprSign(def.getElement().(DecrementOperation).getOperand()).dec()
    )
  }

  Sign implicitSsaDefSign(Ssa::ImplicitDefinition v) {
    result = fieldSign(v.getSourceVariable().getAssignable()) or
    not v.getSourceVariable().getAssignable() instanceof Field
  }

  pragma[inline]
  Sign ssaVariableSign(Ssa::Definition v, Expr e) {
    result = ssaSign(v, any(SsaReadPositionBlock bb | getAnExpression(bb) = e))
  }

  /** Gets a possible sign for `f`. */
  Sign fieldSign(Field f) {
    if f.fromSource() and f.isEffectivelyPrivate()
    then
      result = exprSign(f.getAnAssignedValue())
      or
      any(IncrementOperation inc).getOperand() = f.getAnAccess() and result = fieldSign(f).inc()
      or
      any(DecrementOperation dec).getOperand() = f.getAnAccess() and result = fieldSign(f).dec()
      or
      exists(AssignOperation a | a.getLValue() = f.getAnAccess() | result = exprSign(a))
      or
      not exists(f.getInitializer()) and result = TZero()
    else any()
  }

  predicate unknownIntegerAccess(Expr e) {
    e.getType() instanceof NumericOrCharType and
    not e = getARead(_) and
    not e instanceof FieldAccess and
    // The expression types that are listed here are the ones handled in `specificSubExprSign`.
    // Keep them in sync.
    not e instanceof AssignExpr and
    not e instanceof AssignOperation and
    not e instanceof UnaryPlusExpr and
    not e instanceof PostIncrExpr and
    not e instanceof PostDecrExpr and
    not e instanceof PreIncrExpr and
    not e instanceof PreDecrExpr and
    not e instanceof UnaryMinusExpr and
    not e instanceof ComplementExpr and
    not e instanceof AddExpr and
    not e instanceof SubExpr and
    not e instanceof MulExpr and
    not e instanceof DivExpr and
    not e instanceof RemExpr and
    not e instanceof BitwiseAndExpr and
    not e instanceof BitwiseOrExpr and
    not e instanceof BitwiseXorExpr and
    not e instanceof LShiftExpr and
    not e instanceof RShiftExpr and
    not e instanceof ConditionalExpr and
    not e instanceof RefExpr and
    not e instanceof LocalVariableDeclAndInitExpr and
    not e instanceof SwitchCaseExpr and
    not e instanceof CastExpr and
    not e instanceof SwitchExpr and
    not e instanceof NullCoalescingExpr
  }

  Sign specificSubExprSign(Expr e) {
    // The expression types that are handled here should be excluded in `unknownIntegerAccess`.
    // Keep them in sync.
    result = exprSign(e.(AssignExpr).getRValue())
    or
    result = exprSign(e.(AssignOperation).getExpandedAssignment())
    or
    result = exprSign(e.(UnaryPlusExpr).getOperand())
    or
    result = exprSign(e.(PostIncrExpr).getOperand())
    or
    result = exprSign(e.(PostDecrExpr).getOperand())
    or
    result = exprSign(e.(PreIncrExpr).getOperand()).inc()
    or
    result = exprSign(e.(PreDecrExpr).getOperand()).dec()
    or
    result = exprSign(e.(UnaryMinusExpr).getOperand()).neg()
    or
    result = exprSign(e.(ComplementExpr).getOperand()).bitnot()
    or
    e =
      any(DivExpr div |
        result = exprSign(div.getLeftOperand()) and
        result != TZero() and
        div.getRightOperand().(RealLiteral).getValue().toFloat() = 0
      )
    or
    exists(Sign s1, Sign s2 | binaryOpSigns(e, s1, s2) |
      e instanceof AddExpr and result = s1.add(s2)
      or
      e instanceof SubExpr and result = s1.add(s2.neg())
      or
      e instanceof MulExpr and result = s1.mul(s2)
      or
      e instanceof DivExpr and result = s1.div(s2)
      or
      e instanceof RemExpr and result = s1.rem(s2)
      or
      e instanceof BitwiseAndExpr and result = s1.bitand(s2)
      or
      e instanceof BitwiseOrExpr and result = s1.bitor(s2)
      or
      e instanceof BitwiseXorExpr and result = s1.bitxor(s2)
      or
      e instanceof LShiftExpr and result = s1.lshift(s2)
      or
      e instanceof RShiftExpr and result = s1.rshift(s2)
    )
    or
    result = exprSign(e.(ConditionalExpr).getAChild())
    or
    result = exprSign(e.(NullCoalescingExpr).getAChild())
    or
    result = exprSign(e.(SwitchExpr).getACase().getBody())
    or
    result = exprSign(e.(CastExpr).getExpr())
    or
    result = exprSign(e.(SwitchCaseExpr).getBody())
    or
    result = exprSign(e.(LocalVariableDeclAndInitExpr).getInitializer())
    or
    result = exprSign(e.(RefExpr).getExpr())
  }

  private Sign binaryOpLhsSign(BinaryOperation e) { result = exprSign(e.getLeftOperand()) }

  private Sign binaryOpRhsSign(BinaryOperation e) { result = exprSign(e.getRightOperand()) }

  pragma[noinline]
  private predicate binaryOpSigns(Expr e, Sign lhs, Sign rhs) {
    lhs = binaryOpLhsSign(e) and
    rhs = binaryOpRhsSign(e)
  }

  Expr getARead(Ssa::Definition v) { result = v.getARead() }

  Field getField(FieldAccess fa) { result = fa.getTarget() }

  Expr getAnExpression(SsaReadPositionBlock bb) { result = bb.getBlock().getANode().getElement() }

  Guard getComparisonGuard(ComparisonExpr ce) { result = ce.getExpr() }

  /**
   * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
   */
  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    exists(BooleanValue b | b.getValue() = testIsTrue |
      guard.controlsNode(controlled.(SsaReadPositionBlock).getBlock().getANode(), _, b)
    )
  }

  /** A relational comparison */
  class ComparisonExpr extends ComparisonTest {
    private boolean strict;

    ComparisonExpr() {
      this.getComparisonKind() =
        any(ComparisonKind ck |
          ck.isLessThan() and strict = true
          or
          ck.isLessThanEquals() and
          strict = false
        )
    }

    /**
     * Gets the operand on the "greater" (or "greater-or-equal") side
     * of this relational expression, that is, the side that is larger
     * if the overall expression evaluates to `true`; for example on
     * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
     */
    Expr getGreaterOperand() { result = this.getSecondArgument() }

    /**
     * Gets the operand on the "lesser" (or "lesser-or-equal") side
     * of this relational expression, that is, the side that is smaller
     * if the overall expression evaluates to `true`; for example on
     * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
     */
    Expr getLesserOperand() { result = this.getFirstArgument() }

    /** Holds if this comparison is strict, i.e. `<` or `>`. */
    predicate isStrict() { strict = true }
  }
}
