/**
 * Provides C#-specific definitions for use in sign analysis.
 */
module Private {
  private import csharp as CS
  private import SsaUtils as SU
  private import ConstantUtils as CU
  private import RangeUtils as RU
  private import Sign
  import Impl

  class Guard = RU::Guard;

  class ConstantIntegerExpr = CU::ConstantIntegerExpr;

  class SsaVariable = CS::Ssa::Definition;

  class SsaPhiNode = CS::Ssa::PhiNode;

  class VarAccess = RU::ExprNode::AssignableAccess;

  class FieldAccess = RU::ExprNode::FieldAccess;

  class CharacterLiteral = RU::ExprNode::CharLiteral;

  class IntegerLiteral = RU::ExprNode::IntegerLiteral;

  class LongLiteral = RU::ExprNode::LongLiteral;

  class CastExpr = RU::ExprNode::CastExpr;

  class Type = CS::Type;

  class Expr = CS::ControlFlow::Nodes::ExprNode;

  class VariableUpdate = CS::Ssa::ExplicitDefinition;

  class Field = CS::Field;

  class RealLiteral = RU::ExprNode::RealLiteral;

  class DivExpr = RU::ExprNode::DivExpr;

  class UnaryOperation = RU::ExprNode::UnaryOperation;

  class BinaryOperation = RU::ExprNode::BinaryOperation;

  predicate ssaRead = SU::ssaRead/2;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;
}

private module Impl {
  private import csharp
  private import SsaUtils
  private import RangeUtils
  private import ConstantUtils
  private import Linq.Helpers
  private import Sign
  private import SignAnalysisCommon
  private import SsaReadPositionCommon
  private import semmle.code.csharp.commons.ComparisonTest

  private class ExprNode = ControlFlow::Nodes::ExprNode;

  /** Gets the character value of expression `e`. */
  string getCharValue(ExprNode e) { result = e.getValue() and e.getType() instanceof CharType }

  /** Gets the constant `float` value of non-`ConstantIntegerExpr` expressions. */
  float getNonIntegerValue(ExprNode e) {
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
  predicate containerSizeAccess(ExprNode e) {
    exists(Property p | p = e.getExpr().(PropertyAccess).getTarget() |
      propertyOverrides(p, "System.Collections.Generic.IEnumerable<>", "Count") or
      propertyOverrides(p, "System.Collections.ICollection", "Count") or
      propertyOverrides(p, "System.String", "Length") or
      propertyOverrides(p, "System.Array", "Length")
    )
    or
    e.getExpr() instanceof CountCall
  }

  /** Holds if `e` is by definition strictly positive. */
  predicate positiveExpression(ExprNode e) { e.getExpr() instanceof SizeofExpr }

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
  Ssa::ExplicitDefinition getExplicitSsaAssignment(Ssa::ExplicitDefinition v) { result = v }

  /** Returns the assignment of the variable update `def`. */
  ExprNode getExprFromSsaAssignment(Ssa::ExplicitDefinition def) {
    exists(AssignableDefinition adef |
      adef = def.getADefinition() and
      hasChild(adef.getExpr(), adef.getSource(), def.getControlFlowNode(), result)
    )
  }

  /** Holds if `def` can have any sign. */
  predicate explicitSsaDefWithAnySign(Ssa::ExplicitDefinition def) {
    not exists(def.getADefinition().getSource()) and
    not def.getElement() instanceof MutatorOperation
  }

  /** Returns the operand of the operation if `def` is a decrement. */
  ExprNode getDecrementOperand(Ssa::ExplicitDefinition def) {
    hasChild(def.getElement(), def.getElement().(DecrementOperation).getOperand(),
      def.getControlFlowNode(), result)
  }

  /** Returns the operand of the operation if `def` is an increment. */
  ExprNode getIncrementOperand(Ssa::ExplicitDefinition def) {
    hasChild(def.getElement(), def.getElement().(IncrementOperation).getOperand(),
      def.getControlFlowNode(), result)
  }

  /** Gets the variable underlying the implicit SSA variable `def`. */
  Declaration getImplicitSsaDeclaration(Ssa::ImplicitDefinition def) {
    result = def.getSourceVariable().getAssignable()
  }

  /** Holds if the variable underlying the implicit SSA variable `def` is not a field. */
  predicate nonFieldImplicitSsaDefinition(Ssa::ImplicitDefinition def) {
    not getImplicitSsaDeclaration(def) instanceof Field
  }

  /** Returned an expression that is assigned to `f`. */
  ExprNode getAssignedValueToField(Field f) {
    result.getExpr() in [
        f.getAnAssignedValue(), any(AssignOperation a | a.getLValue() = f.getAnAccess())
      ]
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
  predicate numericExprWithUnknownSign(ExprNode e) {
    e.getType() instanceof NumericOrCharType and
    not e = getARead(_) and
    not e.getExpr() instanceof FieldAccess and
    not e.getExpr() instanceof TypeAccess and
    // The expression types that are listed here are the ones handled in `specificSubExprSign`.
    // Keep them in sync.
    not e.getExpr() instanceof AssignExpr and
    not e.getExpr() instanceof AssignOperation and
    not e.getExpr() instanceof UnaryPlusExpr and
    not e.getExpr() instanceof PostIncrExpr and
    not e.getExpr() instanceof PostDecrExpr and
    not e.getExpr() instanceof PreIncrExpr and
    not e.getExpr() instanceof PreDecrExpr and
    not e.getExpr() instanceof UnaryMinusExpr and
    not e.getExpr() instanceof ComplementExpr and
    not e.getExpr() instanceof AddExpr and
    not e.getExpr() instanceof SubExpr and
    not e.getExpr() instanceof MulExpr and
    not e.getExpr() instanceof DivExpr and
    not e.getExpr() instanceof RemExpr and
    not e.getExpr() instanceof BitwiseAndExpr and
    not e.getExpr() instanceof BitwiseOrExpr and
    not e.getExpr() instanceof BitwiseXorExpr and
    not e.getExpr() instanceof LShiftExpr and
    not e.getExpr() instanceof RShiftExpr and
    not e.getExpr() instanceof ConditionalExpr and
    not e.getExpr() instanceof RefExpr and
    not e.getExpr() instanceof LocalVariableDeclAndInitExpr and
    not e.getExpr() instanceof SwitchCaseExpr and
    not e.getExpr() instanceof CastExpr and
    not e.getExpr() instanceof SwitchExpr and
    not e.getExpr() instanceof NullCoalescingExpr
  }

  /** Returns a sub expression of `e` for expression types where the sign depends on the child. */
  ExprNode getASubExprWithSameSign(ExprNode e) {
    exists(Expr e_, Expr child | hasChild(e_, child, e, result) |
      child = e_.(AssignExpr).getRValue() or
      child = e_.(UnaryPlusExpr).getOperand() or
      child = e_.(PostIncrExpr).getOperand() or
      child = e_.(PostDecrExpr).getOperand() or
      child = e_.(ConditionalExpr).getAChild() or
      child = e_.(NullCoalescingExpr).getAChild() or
      child = e_.(SwitchExpr).getACase() or
      child = e_.(SwitchCaseExpr).getBody() or
      child = e_.(LocalVariableDeclAndInitExpr).getInitializer() or
      child = e_.(RefExpr).getExpr() or
      child = e_.(CastExpr).getExpr()
    )
  }

  ExprNode getARead(Ssa::Definition v) { exists(v.getAReadAtNode(result)) }

  Field getField(ExprNode fa) { result = fa.getExpr().(FieldAccess).getTarget() }

  ExprNode getAnExpression(SsaReadPositionBlock bb) { result = bb.getBlock().getANode() }

  Guard getComparisonGuard(ComparisonExpr ce) { result = ce.getExpr() }

  private newtype TComparisonExpr =
    MkComparisonExpr(ComparisonTest ct, ExprNode e) { e = ct.getExpr().getAControlFlowNode() }

  /** A relational comparison */
  class ComparisonExpr extends MkComparisonExpr {
    private ComparisonTest ct;
    private ExprNode e;
    private boolean strict;

    ComparisonExpr() {
      this = MkComparisonExpr(ct, e) and
      ct.getComparisonKind() =
        any(ComparisonKind ck |
          ck.isLessThan() and strict = true
          or
          ck.isLessThanEquals() and
          strict = false
        )
    }

    /** Gets the underlying expression. */
    Expr getExpr() { result = ct.getExpr() }

    /** Gets a textual representation of this comparison test. */
    string toString() { result = ct.toString() }

    /** Gets the location of this comparison test. */
    Location getLocation() { result = ct.getLocation() }

    /**
     * Gets the operand on the "greater" (or "greater-or-equal") side
     * of this relational expression, that is, the side that is larger
     * if the overall expression evaluates to `true`; for example on
     * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
     */
    ExprNode getGreaterOperand() { hasChild(ct.getExpr(), ct.getSecondArgument(), e, result) }

    /**
     * Gets the operand on the "lesser" (or "lesser-or-equal") side
     * of this relational expression, that is, the side that is smaller
     * if the overall expression evaluates to `true`; for example on
     * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
     */
    ExprNode getLesserOperand() { hasChild(ct.getExpr(), ct.getFirstArgument(), e, result) }

    /** Holds if this comparison is strict, i.e. `<` or `>`. */
    predicate isStrict() { strict = true }
  }
}
