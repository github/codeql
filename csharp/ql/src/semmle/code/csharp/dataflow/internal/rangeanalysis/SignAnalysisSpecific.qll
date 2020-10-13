/**
 * Provides C#-specific definitions for use in sign analysis.
 */
module Private {
  private import csharp as CS
  private import SsaUtils as SU
  private import ConstantUtils as CU
  private import RangeUtils as RU
  private import semmle.code.csharp.controlflow.Guards as G
  private import Sign
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

  class Field = CS::Field;

  class RealLiteral = CS::RealLiteral;

  class DivExpr = CS::DivExpr;

  /** Class to represent unary operation. */
  class UnaryOperation extends Expr {
    UnaryOperation() {
      this instanceof CS::PreIncrExpr or
      this instanceof CS::PreDecrExpr or
      this instanceof CS::UnaryMinusExpr or
      this instanceof CS::ComplementExpr
    }

    /** Returns the operand of this expression. */
    Expr getOperand() {
      result = this.(CS::PreIncrExpr).getOperand() or
      result = this.(CS::PreDecrExpr).getOperand() or
      result = this.(CS::UnaryMinusExpr).getOperand() or
      result = this.(CS::ComplementExpr).getOperand()
    }

    /** Returns the operation representing this expression. */
    TUnarySignOperation getOp() {
      this instanceof CS::PreIncrExpr and result = TIncOp()
      or
      this instanceof CS::PreDecrExpr and result = TDecOp()
      or
      this instanceof CS::UnaryMinusExpr and result = TNegOp()
      or
      this instanceof CS::ComplementExpr and result = TBitNotOp()
    }
  }

  /** Class to represent binary operation. */
  class BinaryOperation extends CS::BinaryOperation {
    BinaryOperation() {
      this instanceof CS::AddExpr or
      this instanceof CS::SubExpr or
      this instanceof CS::MulExpr or
      this instanceof CS::DivExpr or
      this instanceof CS::RemExpr or
      this instanceof CS::BitwiseAndExpr or
      this instanceof CS::BitwiseOrExpr or
      this instanceof CS::BitwiseXorExpr or
      this instanceof CS::LShiftExpr or
      this instanceof CS::RShiftExpr
    }

    /** Returns the operation representing this expression. */
    TBinarySignOperation getOp() {
      this instanceof CS::AddExpr and result = TAddOp()
      or
      this instanceof CS::SubExpr and result = TSubOp()
      or
      this instanceof CS::MulExpr and result = TMulOp()
      or
      this instanceof CS::DivExpr and result = TDivOp()
      or
      this instanceof CS::RemExpr and result = TRemOp()
      or
      this instanceof CS::BitwiseAndExpr and result = TBitAndOp()
      or
      this instanceof CS::BitwiseOrExpr and result = TBitOrOp()
      or
      this instanceof CS::BitwiseXorExpr and result = TBitXorOp()
      or
      this instanceof CS::LShiftExpr and result = TLShiftOp()
      or
      this instanceof CS::RShiftExpr and result = TRShiftOp()
    }
  }

  predicate ssaRead = SU::ssaRead/2;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;
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

  /** Gets the constant `float` value of non-`ConstantIntegerExpr` expressions. */
  float getNonIntegerValue(Expr e) {
    exists(string s |
      s = e.getValue() and
      result = s.toFloat() and
      not exists(s.toInt())
    )
  }

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

  /** Returns a sub expression of `e` for expression types where the sign depends on the child. */
  Expr getASubExprWithSameSign(Expr e) {
    result = e.(AssignExpr).getRValue() or
    result = e.(AssignOperation).getExpandedAssignment() or
    result = e.(UnaryPlusExpr).getOperand() or
    result = e.(PostIncrExpr).getOperand() or
    result = e.(PostDecrExpr).getOperand() or
    result = e.(ConditionalExpr).getAChild() or
    result = e.(NullCoalescingExpr).getAChild() or
    result = e.(SwitchExpr).getACase().getBody() or
    result = e.(SwitchCaseExpr).getBody() or
    result = e.(LocalVariableDeclAndInitExpr).getInitializer() or
    result = e.(RefExpr).getExpr() or
    result = e.(CastExpr).getExpr()
  }

  Expr getARead(Ssa::Definition v) { result = v.getARead() }

  Field getField(FieldAccess fa) { result = fa.getTarget() }

  Expr getAnExpression(SsaReadPositionBlock bb) { result = bb.getBlock().getANode().getElement() }

  Guard getComparisonGuard(ComparisonExpr ce) { result = ce.getExpr() }

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
