/**
 * Provides Java-specific definitions for use in sign analysis.
 */
module Private {
  import semmle.code.java.dataflow.RangeUtils as RU
  private import semmle.code.java.dataflow.SSA as Ssa
  private import semmle.code.java.controlflow.Guards as G
  private import java as J
  import Impl

  class ConstantIntegerExpr = RU::ConstantIntegerExpr;

  class Guard = G::Guard;

  class SsaVariable = Ssa::SsaVariable;

  class SsaPhiNode = Ssa::SsaPhiNode;

  class VarAccess = J::VarAccess;

  class FieldAccess = J::FieldAccess;

  class CharacterLiteral = J::CharacterLiteral;

  class IntegerLiteral = J::IntegerLiteral;

  class LongLiteral = J::LongLiteral;

  class CastExpr = J::CastExpr;

  class Type = J::Type;

  class Expr = J::Expr;

  class ComparisonExpr = J::ComparisonExpr;

  class NumericOrCharType = J::NumericOrCharType;

  class VariableUpdate = J::VariableUpdate;

  class ExprWithPossibleValue = J::Literal;

  class Field = J::Field;

  predicate ssaRead = RU::ssaRead/2;

  predicate guardControlsSsaRead = RU::guardControlsSsaRead/3;
}

private module Impl {
  private import java
  private import semmle.code.java.dataflow.RangeUtils
  private import semmle.code.java.dataflow.SSA
  private import semmle.code.java.controlflow.Guards
  private import semmle.code.java.Reflection
  private import semmle.code.java.Collections
  private import semmle.code.java.Maps
  private import Sign
  private import SignAnalysisCommon
  private import SsaReadPositionCommon

  class UnsignedNumericType = CharacterType;

  /** Gets the character value of expression `e`. */
  string getCharValue(Expr e) { result = e.(CharacterLiteral).getValue() }

  /**
   * Holds if `e` is an access to the size of a container (`string`, `Map`, or
   * `Collection`).
   */
  predicate containerSizeAccess(Expr e) {
    e.(MethodAccess).getMethod() instanceof StringLengthMethod
    or
    e.(MethodAccess).getMethod() instanceof CollectionSizeMethod
    or
    e.(MethodAccess).getMethod() instanceof MapSizeMethod
  }

  /** Holds if `e` is by definition strictly positive. */
  predicate positiveExpression(Expr e) { none() }

  /**
   * Holds if `e` has type `NumericOrCharType`, but the sign of `e` is unknown.
   */
  predicate numericExprWithUnknownSign(Expr e) {
    // The expression types handled in the predicate complements the expression
    // types handled in `specificSubExprSign`.
    e instanceof ArrayAccess and e.getType() instanceof NumericOrCharType
    or
    e instanceof MethodAccess and e.getType() instanceof NumericOrCharType
    or
    e instanceof ClassInstanceExpr and e.getType() instanceof NumericOrCharType
  }

  /** Returns the underlying variable update of the explicit SSA variable `v`. */
  VariableUpdate getExplicitSsaAssignment(SsaVariable v) {
    result = v.(SsaExplicitUpdate).getDefiningExpr()
  }

  /** Returns the assignment of the variable update `def`. */
  Expr getExprFromSsaAssignment(VariableUpdate def) {
    result = def.(VariableAssign).getSource()
    or
    exists(AssignOp a | a = def and result = a)
  }

  /** Holds if `def` can have any sign. */
  predicate explicitSsaDefWithAnySign(VariableUpdate def) {
    exists(EnhancedForStmt for | def = for.getVariable())
  }

  /** Returns the operand of the operation if `def` is a decrement. */
  Expr getDecrementOperand(Element e) {
    result = e.(PostDecExpr).getExpr() or result = e.(PreDecExpr).getExpr()
  }

  /** Returns the operand of the operation if `def` is an increment. */
  Expr getIncrementOperand(Element e) {
    result = e.(PostIncExpr).getExpr() or result = e.(PreIncExpr).getExpr()
  }

  /** Gets the variable underlying the implicit SSA variable `v`. */
  Variable getImplicitSsaDeclaration(SsaVariable v) {
    result = v.(SsaImplicitUpdate).getSourceVariable().getVariable() or
    result = v.(SsaImplicitInit).getSourceVariable().getVariable()
  }

  /** Holds if the variable underlying the implicit SSA variable `v` is not a field. */
  predicate nonFieldImplicitSsaDefinition(SsaImplicitInit v) {
    exists(Parameter p | v.isParameterDefinition(p))
  }

  /** Returned an expression that is assigned to `f`. */
  Expr getAssignedValueToField(Field f) {
    result = f.getAnAssignedValue() or
    result = any(AssignOp a | a.getDest() = f.getAnAccess())
  }

  /** Holds if `f` can have any sign. */
  predicate fieldWithUnknownSign(Field f) {
    exists(ReflectiveFieldAccess rfa | rfa.inferAccessedField() = f)
  }

  /** Holds if `f` is accessed in an increment operation. */
  predicate fieldIncrementOperationOperand(Field f) {
    any(PostIncExpr inc).getExpr() = f.getAnAccess() or
    any(PreIncExpr inc).getExpr() = f.getAnAccess()
  }

  /** Holds if `f` is accessed in a decrement operation. */
  predicate fieldDecrementOperationOperand(Field f) {
    any(PostDecExpr dec).getExpr() = f.getAnAccess() or
    any(PreDecExpr dec).getExpr() = f.getAnAccess()
  }

  /** Returns possible signs of `f` based on the declaration. */
  Sign specificFieldSign(Field f) {
    if f.fromSource()
    then not exists(f.getInitializer()) and result = TZero()
    else
      if f instanceof ArrayLengthField
      then result != TNeg()
      else
        if f.hasName("MAX_VALUE")
        then result = TPos()
        else
          if f.hasName("MIN_VALUE")
          then result = TNeg()
          else anySign(result)
  }

  /** Gets a possible sign for `e` from the signs of its child nodes. */
  Sign specificSubExprSign(Expr e) {
    result = exprSign(e.(AssignExpr).getSource())
    or
    result = exprSign(e.(PlusExpr).getExpr())
    or
    result = exprSign(e.(PostIncExpr).getExpr())
    or
    result = exprSign(e.(PostDecExpr).getExpr())
    or
    result = exprSign(e.(PreIncExpr).getExpr()).inc()
    or
    result = exprSign(e.(PreDecExpr).getExpr()).dec()
    or
    result = exprSign(e.(MinusExpr).getExpr()).neg()
    or
    result = exprSign(e.(BitNotExpr).getExpr()).bitnot()
    or
    exists(DivExpr div |
      div = e and
      result = exprSign(div.getLeftOperand()) and
      result != TZero()
    |
      div.getRightOperand().(FloatingPointLiteral).getValue().toFloat() = 0 or
      div.getRightOperand().(DoubleLiteral).getValue().toFloat() = 0
    )
    or
    exists(Sign s1, Sign s2 | binaryOpSigns(e, s1, s2) |
      (e instanceof AssignAddExpr or e instanceof AddExpr) and
      result = s1.add(s2)
      or
      (e instanceof AssignSubExpr or e instanceof SubExpr) and
      result = s1.add(s2.neg())
      or
      (e instanceof AssignMulExpr or e instanceof MulExpr) and
      result = s1.mul(s2)
      or
      (e instanceof AssignDivExpr or e instanceof DivExpr) and
      result = s1.div(s2)
      or
      (e instanceof AssignRemExpr or e instanceof RemExpr) and
      result = s1.rem(s2)
      or
      (e instanceof AssignAndExpr or e instanceof AndBitwiseExpr) and
      result = s1.bitand(s2)
      or
      (e instanceof AssignOrExpr or e instanceof OrBitwiseExpr) and
      result = s1.bitor(s2)
      or
      (e instanceof AssignXorExpr or e instanceof XorBitwiseExpr) and
      result = s1.bitxor(s2)
      or
      (e instanceof AssignLShiftExpr or e instanceof LShiftExpr) and
      result = s1.lshift(s2)
      or
      (e instanceof AssignRShiftExpr or e instanceof RShiftExpr) and
      result = s1.rshift(s2)
      or
      (e instanceof AssignURShiftExpr or e instanceof URShiftExpr) and
      result = s1.urshift(s2)
    )
    or
    result = exprSign(e.(ChooseExpr).getAResultExpr())
    or
    result = exprSign(e.(CastExpr).getExpr())
  }

  private Sign binaryOpLhsSign(Expr e) {
    result = exprSign(e.(BinaryExpr).getLeftOperand()) or
    result = exprSign(e.(AssignOp).getDest())
  }

  private Sign binaryOpRhsSign(Expr e) {
    result = exprSign(e.(BinaryExpr).getRightOperand()) or
    result = exprSign(e.(AssignOp).getRhs())
  }

  pragma[noinline]
  private predicate binaryOpSigns(Expr e, Sign lhs, Sign rhs) {
    lhs = binaryOpLhsSign(e) and
    rhs = binaryOpRhsSign(e)
  }

  Expr getARead(SsaVariable v) { result = v.getAUse() }

  Field getField(FieldAccess fa) { result = fa.getField() }

  Expr getAnExpression(SsaReadPositionBlock bb) { result = bb.getBlock().getANode() }

  Guard getComparisonGuard(ComparisonExpr ce) { result = ce }
}
