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

  class VariableUpdate = CS::AssignableDefinition;

  class ExprWithPossibleValue = CS::Expr;

  class Field = CS::Field;

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

  /** Gets the character value of expression `e`. */
  string getCharValue(Expr e) { result = e.getValue() and e.getType() instanceof CharType }

  /**
   * Holds if `e` is an access to the size of a container (`string`, `Array`,
   * `IEnumerable`, or `ICollection`).
   */
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

  /** Holds if `e` is by definition strictly positive. */
  predicate positiveExpression(Expr e) { e instanceof SizeofExpr }

  abstract class NumericOrCharType extends Type { }

  class UnsignedNumericType extends NumericOrCharType {
    UnsignedNumericType() {
      this instanceof CharType
      or
      this instanceof UnsignedIntegralType
      or
      this instanceof PointerType
      or
      this instanceof Enum and this.(Enum).getUnderlyingType() instanceof UnsignedIntegralType
    }
  }

  class SignedNumericType extends NumericOrCharType {
    SignedNumericType() {
      this instanceof SignedIntegralType
      or
      this instanceof FloatingPointType
      or
      this instanceof DecimalType
      or
      this instanceof Enum and this.(Enum).getUnderlyingType() instanceof SignedIntegralType
    }
  }

  /** Returns the underlying variable update of the explicit SSA variable `v`. */
  AssignableDefinition getExplicitSsaAssignment(Ssa::ExplicitDefinition v) {
    result = v.getADefinition()
  }

  /** Returns the assignment of the variable update `def`. */
  Expr getExprFromSsaAssignment(AssignableDefinition def) { result = def.getSource() }

  /** Holds if `def` can have any sign. */
  predicate explicitSsaDefWithAnySign(AssignableDefinition def) {
    not exists(def.getSource()) and
    not def.getElement() instanceof MutatorOperation
  }

  /** Returns the operand of the operation if `def` is a decrement. */
  Expr getDecrementOperand(AssignableDefinition def) {
    result = def.getElement().(DecrementOperation).getOperand()
  }

  /** Returns the operand of the operation if `def` is an increment. */
  Expr getIncrementOperand(AssignableDefinition def) {
    result = def.getElement().(IncrementOperation).getOperand()
  }

  /** Gets the variable underlying the implicit SSA variable `v`. */
  Declaration getImplicitSsaDeclaration(Ssa::ImplicitDefinition v) {
    result = v.getSourceVariable().getAssignable()
  }

  /** Holds if the variable underlying the implicit SSA variable `v` is not a field. */
  predicate nonFieldImplicitSsaDefinition(Ssa::ImplicitDefinition v) {
    not getImplicitSsaDeclaration(v) instanceof Field
  }

  /** Returned an expression that is assigned to `f`. */
  Expr getAssignedValueToField(Field f) {
    result = f.getAnAssignedValue() or
    result = any(AssignOperation a | a.getLValue() = f.getAnAccess())
  }

  /** Holds if `f` can have any sign. */
  predicate fieldWithUnknownSign(Field f) { not f.fromSource() or not f.isEffectivelyPrivate() }

  /** Holds if `f` is accessed in an increment operation. */
  predicate fieldIncrementOperationOperand(Field f) {
    any(IncrementOperation inc).getOperand() = f.getAnAccess()
  }

  /** Holds if `f` is accessed in a decrement operation. */
  predicate fieldDecrementOperationOperand(Field f) {
    any(DecrementOperation dec).getOperand() = f.getAnAccess()
  }

  /** Returns possible signs of `f` based on the declaration. */
  pragma[inline]
  Sign specificFieldSign(Field f) { not exists(f.getInitializer()) and result = TZero() }

  /**
   * Holds if `e` has type `NumericOrCharType`, but the sign of `e` is unknown.
   */
  predicate numericExprWithUnknownSign(Expr e) {
    e.getType() instanceof NumericOrCharType and
    not e = getARead(_) and
    not e instanceof FieldAccess and
    not e instanceof TypeAccess and
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

  /** Gets a possible sign for `e` from the signs of its child nodes. */
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
      guard.controlsBasicBlock(controlled.(SsaReadPositionBlock).getBlock(), b)
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
