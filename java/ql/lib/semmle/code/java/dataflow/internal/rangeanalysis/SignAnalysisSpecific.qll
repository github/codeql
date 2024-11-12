/**
 * Provides Java-specific definitions for use in sign analysis.
 */
module Private {
  private import java as J
  import semmle.code.java.dataflow.RangeUtils as RU
  private import semmle.code.java.dataflow.SSA as Ssa
  private import semmle.code.java.controlflow.Guards as G
  private import SsaReadPositionCommon
  private import semmle.code.java.controlflow.internal.GuardsLogic as GL
  private import Sign
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

  class CastingExpr extends J::CastingExpr {
    /** Gets the source type of this cast. */
    J::Type getSourceType() { result = this.getExpr().getType() }
  }

  class Type = J::Type;

  class Expr = J::Expr;

  class ComparisonExpr = J::ComparisonExpr;

  class NumericOrCharType = J::NumericOrCharType;

  class VariableUpdate = J::VariableUpdate;

  class Field = J::Field;

  class DivExpr = J::DivExpr;

  /** Class to represent float and double literals. */
  class RealLiteral extends J::Literal {
    RealLiteral() {
      this instanceof J::FloatLiteral or
      this instanceof J::DoubleLiteral
    }
  }

  /** Class to represent unary operation. */
  class UnaryOperation extends J::Expr {
    UnaryOperation() {
      this instanceof J::PreIncExpr or
      this instanceof J::PreDecExpr or
      this instanceof J::MinusExpr or
      this instanceof J::BitNotExpr
    }

    /** Returns the operand of this expression. */
    Expr getOperand() {
      result = this.(J::PreIncExpr).getExpr() or
      result = this.(J::PreDecExpr).getExpr() or
      result = this.(J::MinusExpr).getExpr() or
      result = this.(J::BitNotExpr).getExpr()
    }

    /** Returns the operation representing this expression. */
    TUnarySignOperation getOp() {
      this instanceof J::PreIncExpr and result = TIncOp()
      or
      this instanceof J::PreDecExpr and result = TDecOp()
      or
      this instanceof J::MinusExpr and result = TNegOp()
      or
      this instanceof J::BitNotExpr and result = TBitNotOp()
    }
  }

  /** Class to represent binary operation. */
  class BinaryOperation extends J::Expr {
    BinaryOperation() {
      this instanceof J::AddExpr or
      this instanceof J::AssignAddExpr or
      this instanceof J::SubExpr or
      this instanceof J::AssignSubExpr or
      this instanceof J::MulExpr or
      this instanceof J::AssignMulExpr or
      this instanceof J::DivExpr or
      this instanceof J::AssignDivExpr or
      this instanceof J::RemExpr or
      this instanceof J::AssignRemExpr or
      this instanceof J::AndBitwiseExpr or
      this instanceof J::AssignAndExpr or
      this instanceof J::OrBitwiseExpr or
      this instanceof J::AssignOrExpr or
      this instanceof J::XorBitwiseExpr or
      this instanceof J::AssignXorExpr or
      this instanceof J::LeftShiftExpr or
      this instanceof J::AssignLeftShiftExpr or
      this instanceof J::RightShiftExpr or
      this instanceof J::AssignRightShiftExpr or
      this instanceof J::UnsignedRightShiftExpr or
      this instanceof J::AssignUnsignedRightShiftExpr
    }

    /** Returns the operation representing this expression. */
    TBinarySignOperation getOp() {
      this instanceof J::AddExpr and result = TAddOp()
      or
      this instanceof J::AssignAddExpr and result = TAddOp()
      or
      this instanceof J::SubExpr and result = TSubOp()
      or
      this instanceof J::AssignSubExpr and result = TSubOp()
      or
      this instanceof J::MulExpr and result = TMulOp()
      or
      this instanceof J::AssignMulExpr and result = TMulOp()
      or
      this instanceof J::DivExpr and result = TDivOp()
      or
      this instanceof J::AssignDivExpr and result = TDivOp()
      or
      this instanceof J::RemExpr and result = TRemOp()
      or
      this instanceof J::AssignRemExpr and result = TRemOp()
      or
      this instanceof J::AndBitwiseExpr and result = TBitAndOp()
      or
      this instanceof J::AssignAndExpr and result = TBitAndOp()
      or
      this instanceof J::OrBitwiseExpr and result = TBitOrOp()
      or
      this instanceof J::AssignOrExpr and result = TBitOrOp()
      or
      this instanceof J::XorBitwiseExpr and result = TBitXorOp()
      or
      this instanceof J::AssignXorExpr and result = TBitXorOp()
      or
      this instanceof J::LeftShiftExpr and result = TLeftShiftOp()
      or
      this instanceof J::AssignLeftShiftExpr and result = TLeftShiftOp()
      or
      this instanceof J::RightShiftExpr and result = TRightShiftOp()
      or
      this instanceof J::AssignRightShiftExpr and result = TRightShiftOp()
      or
      this instanceof J::UnsignedRightShiftExpr and result = TUnsignedRightShiftOp()
      or
      this instanceof J::AssignUnsignedRightShiftExpr and result = TUnsignedRightShiftOp()
    }

    Expr getLeftOperand() {
      result = this.(J::BinaryExpr).getLeftOperand() or result = this.(J::AssignOp).getDest()
    }

    Expr getRightOperand() {
      result = this.(J::BinaryExpr).getRightOperand() or result = this.(J::AssignOp).getRhs()
    }
  }

  predicate ssaRead = RU::ssaRead/2;

  /**
   * Holds if `guard` directly controls the position `controlled` with the
   * value `testIsTrue`.
   */
  pragma[nomagic]
  private predicate guardDirectlyControlsSsaRead(
    Guard guard, SsaReadPosition controlled, boolean testIsTrue
  ) {
    guard.directlyControls(controlled.(SsaReadPositionBlock).getBlock(), testIsTrue)
    or
    exists(SsaReadPositionPhiInputEdge controlledEdge | controlledEdge = controlled |
      guard.directlyControls(controlledEdge.getOrigBlock(), testIsTrue) or
      guard.hasBranchEdge(controlledEdge.getOrigBlock(), controlledEdge.getPhiBlock(), testIsTrue)
    )
  }

  /**
   * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
   */
  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
    guardDirectlyControlsSsaRead(guard, controlled, testIsTrue)
    or
    exists(Guard guard0, boolean testIsTrue0 |
      GL::implies_v2(guard0, testIsTrue0, guard, testIsTrue) and
      guardControlsSsaRead(guard0, controlled, testIsTrue0)
    )
  }
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

  /** Gets the constant `float` value of non-`ConstantIntegerExpr` expressions. */
  float getNonIntegerValue(Expr e) {
    result = e.(LongLiteral).getValue().toFloat() or
    result = e.(FloatLiteral).getValue().toFloat() or
    result = e.(DoubleLiteral).getValue().toFloat()
  }

  /**
   * Holds if `e` is an access to the size of a container (`string`, `Map`, or
   * `Collection`).
   */
  predicate containerSizeAccess(Expr e) {
    e.(MethodCall).getMethod() instanceof StringLengthMethod
    or
    e.(MethodCall).getMethod() instanceof CollectionSizeMethod
    or
    e.(MethodCall).getMethod() instanceof MapSizeMethod
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
    e instanceof MethodCall and e.getType() instanceof NumericOrCharType
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
  predicate nonFieldImplicitSsaDefinition(SsaImplicitInit v) { v.isParameterDefinition(_) }

  /** Returned an expression that is assigned to `f`. */
  Expr getAssignedValueToField(Field f) {
    result = f.getAnAssignedValue() or
    result = any(AssignOp a | a.getDest() = f.getAnAccess())
  }

  /** Holds if `f` can have any sign. */
  predicate fieldWithUnknownSign(Field f) {
    exists(ReflectiveGetFieldCall rfa | rfa.inferAccessedField() = f)
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

  /** Returns a sub expression of `e` for expression types where the sign depends on the child. */
  Expr getASubExprWithSameSign(Expr e) {
    result = e.(AssignExpr).getSource() or
    result = e.(PlusExpr).getExpr() or
    result = e.(PostIncExpr).getExpr() or
    result = e.(PostDecExpr).getExpr() or
    result = e.(ChooseExpr).getAResultExpr() or
    result = e.(CastingExpr).getExpr()
  }

  Expr getARead(SsaVariable v) { result = v.getAUse() }

  Field getField(FieldAccess fa) { result = fa.getField() }

  Expr getAnExpression(SsaReadPositionBlock bb) { result = bb.getBlock().getANode().asExpr() }

  Guard getComparisonGuard(ComparisonExpr ce) { result = ce }
}
