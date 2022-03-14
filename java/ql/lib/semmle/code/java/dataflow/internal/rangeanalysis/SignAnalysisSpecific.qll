/**
 * Provides Java-specific definitions for use in sign analysis.
 */
module Private {
  private import java as J
  private import Sign
  private import semmle.code.java.semantic.SemanticExpr
  private import semmle.code.java.semantic.SemanticGuard
  private import semmle.code.java.semantic.SemanticSSA
  import Impl

  /** Class to represent unary operation. */
  class UnaryOperation extends SemUnaryExpr {
    UnaryOperation() {
      expr instanceof J::PreIncExpr or
      expr instanceof J::PreDecExpr or
      expr instanceof J::MinusExpr or
      expr instanceof J::BitNotExpr
    }

    /** Returns the operand of this expression. */
    SemExpr getOperand() { result = getExpr() }

    /** Returns the operation representing this expression. */
    TUnarySignOperation getOp() {
      this instanceof SemPreIncExpr and result = TIncOp()
      or
      this instanceof SemPreDecExpr and result = TDecOp()
      or
      this instanceof SemMinusExpr and result = TNegOp()
      or
      this instanceof SemBitNotExpr and result = TBitNotOp()
    }
  }

  /** Class to represent binary operation. */
  class BinaryOperation extends SemExpr {
    BinaryOperation() {
      expr instanceof J::AddExpr or
      expr instanceof J::AssignAddExpr or
      expr instanceof J::SubExpr or
      expr instanceof J::AssignSubExpr or
      expr instanceof J::MulExpr or
      expr instanceof J::AssignMulExpr or
      expr instanceof J::DivExpr or
      expr instanceof J::AssignDivExpr or
      expr instanceof J::RemExpr or
      expr instanceof J::AssignRemExpr or
      expr instanceof J::AndBitwiseExpr or
      expr instanceof J::AssignAndExpr or
      expr instanceof J::OrBitwiseExpr or
      expr instanceof J::AssignOrExpr or
      expr instanceof J::XorBitwiseExpr or
      expr instanceof J::AssignXorExpr or
      expr instanceof J::LShiftExpr or
      expr instanceof J::AssignLShiftExpr or
      expr instanceof J::RShiftExpr or
      expr instanceof J::AssignRShiftExpr or
      expr instanceof J::URShiftExpr or
      expr instanceof J::AssignURShiftExpr
    }

    /** Returns the operation representing this expression. */
    TBinarySignOperation getOp() {
      expr instanceof J::AddExpr and result = TAddOp()
      or
      expr instanceof J::AssignAddExpr and result = TAddOp()
      or
      expr instanceof J::SubExpr and result = TSubOp()
      or
      expr instanceof J::AssignSubExpr and result = TSubOp()
      or
      expr instanceof J::MulExpr and result = TMulOp()
      or
      expr instanceof J::AssignMulExpr and result = TMulOp()
      or
      expr instanceof J::DivExpr and result = TDivOp()
      or
      expr instanceof J::AssignDivExpr and result = TDivOp()
      or
      expr instanceof J::RemExpr and result = TRemOp()
      or
      expr instanceof J::AssignRemExpr and result = TRemOp()
      or
      expr instanceof J::AndBitwiseExpr and result = TBitAndOp()
      or
      expr instanceof J::AssignAndExpr and result = TBitAndOp()
      or
      expr instanceof J::OrBitwiseExpr and result = TBitOrOp()
      or
      expr instanceof J::AssignOrExpr and result = TBitOrOp()
      or
      expr instanceof J::XorBitwiseExpr and result = TBitXorOp()
      or
      expr instanceof J::AssignXorExpr and result = TBitXorOp()
      or
      expr instanceof J::LShiftExpr and result = TLShiftOp()
      or
      expr instanceof J::AssignLShiftExpr and result = TLShiftOp()
      or
      expr instanceof J::RShiftExpr and result = TRShiftOp()
      or
      expr instanceof J::AssignRShiftExpr and result = TRShiftOp()
      or
      expr instanceof J::URShiftExpr and result = TURShiftOp()
      or
      expr instanceof J::AssignURShiftExpr and result = TURShiftOp()
    }

    SemExpr getLeftOperand() {
      result = this.(SemBinaryExpr).getLeftOperand() or result = this.(SemAssignOp).getDest()
    }

    SemExpr getRightOperand() {
      result = this.(SemBinaryExpr).getRightOperand() or result = this.(SemAssignOp).getRhs()
    }
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
  private import semmle.code.java.semantic.SemanticExpr
  private import semmle.code.java.semantic.SemanticGuard
  private import semmle.code.java.semantic.SemanticSSA
  private import SsaReadPositionCommon

  /**
   * Holds if `e` is an access to the size of a container (`string`, `Map`, or
   * `Collection`).
   */
  private predicate containerSizeAccess(SemExpr e) {
    exists(Method method | method = getJavaExpr(e).(MethodAccess).getMethod() |
      method instanceof StringLengthMethod
      or
      method instanceof CollectionSizeMethod
      or
      method instanceof MapSizeMethod
    )
  }

  /**
   * Holds if `e` has type `NumericOrCharType`, but the sign of `e` is unknown.
   */
  predicate numericExprWithUnknownSign(SemExpr e) {
    exists(Expr expr | expr = getJavaExpr(e) |
      // The expression types handled in the predicate complements the expression
      // types handled in `specificSubExprSign`.
      expr instanceof ArrayAccess and expr.getType() instanceof NumericOrCharType
      or
      expr instanceof MethodAccess and expr.getType() instanceof NumericOrCharType
      or
      expr instanceof ClassInstanceExpr and expr.getType() instanceof NumericOrCharType
    )
  }

  /** Returns the underlying variable update of the explicit SSA variable `v`. */
  SemVariableUpdate getExplicitSsaAssignment(SemSsaVariable v) {
    result = v.(SemSsaExplicitUpdate).getDefiningExpr()
  }

  /** Returns the assignment of the variable update `def`. */
  SemExpr getExprFromSsaAssignment(SemVariableUpdate def) {
    result = def.(SemVariableAssign).getSource()
    or
    exists(SemAssignOp a | a = def and result = a)
  }

  /** Holds if `def` can have any sign. */
  predicate explicitSsaDefWithAnySign(SemVariableUpdate def) {
    exists(EnhancedForStmt for | def = getSemanticExpr(for.getVariable()))
  }

  /** Gets the variable underlying the implicit SSA variable `v`. */
  private Variable getImplicitSsaDeclaration(SsaVariable v) {
    result = v.(SsaImplicitUpdate).getSourceVariable().getVariable() or
    result = v.(SsaImplicitInit).getSourceVariable().getVariable()
  }

  /** Holds if the variable underlying the implicit SSA variable `v` is not a field. */
  private predicate nonFieldImplicitSsaDefinition(SsaImplicitInit v) {
    exists(Parameter p | v.isParameterDefinition(p))
  }

  /** Returns the sign of implicit SSA definition `v`. */
  Sign implicitSsaDefSign(SemSsaVariable v) {
    exists(SsaVariable javaVariable | javaVariable = getJavaSsaVariable(v) |
      result = fieldSign(getImplicitSsaDeclaration(javaVariable))
      or
      anySign(result) and nonFieldImplicitSsaDefinition(javaVariable)
    )
  }

  /** Gets a possible sign for `f`. */
  private Sign fieldSign(Field f) {
    if not fieldWithUnknownSign(f)
    then
      result = semExprSign(getAssignedValueToField(f))
      or
      fieldIncrementOperationOperand(f) and result = fieldSign(f).inc()
      or
      fieldDecrementOperationOperand(f) and result = fieldSign(f).dec()
      or
      result = specificFieldSign(f)
    else anySign(result)
  }

  /** Returned an expression that is assigned to `f`. */
  private SemExpr getAssignedValueToField(Field f) {
    result = getSemanticExpr(f.getAnAssignedValue()) or
    result = any(SemAssignOp a | a.getDest() = getSemanticExpr(f.getAnAccess()))
  }

  /** Holds if `f` can have any sign. */
  private predicate fieldWithUnknownSign(Field f) {
    exists(ReflectiveFieldAccess rfa | rfa.inferAccessedField() = f)
  }

  /** Holds if `f` is accessed in an increment operation. */
  private predicate fieldIncrementOperationOperand(Field f) {
    any(PostIncExpr inc).getExpr() = f.getAnAccess() or
    any(PreIncExpr inc).getExpr() = f.getAnAccess()
  }

  /** Holds if `f` is accessed in a decrement operation. */
  private predicate fieldDecrementOperationOperand(Field f) {
    any(PostDecExpr dec).getExpr() = f.getAnAccess() or
    any(PreDecExpr dec).getExpr() = f.getAnAccess()
  }

  /** Returns possible signs of `f` based on the declaration. */
  private Sign specificFieldSign(Field f) {
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
  SemExpr getASubExprWithSameSign(SemExpr e) {
    result = e.(SemAssignExpr).getRhs() or
    result = e.(SemPlusExpr).getExpr() or
    result = e.(SemPostIncExpr).getExpr() or
    result = e.(SemPostDecExpr).getExpr() or
    result = getSemanticExpr(getJavaExpr(e).(ChooseExpr).getAResultExpr()) or
    result = e.(SemCastExpr).getExpr()
  }

  private Field getField(FieldAccess fa) { result = fa.getField() }

  Sign getVarAccessSign(SemVarAccess access) {
    result = fieldSign(getField(getJavaExpr(access).(FieldAccess)))
    or
    anySign(result) and not getJavaExpr(access) instanceof FieldAccess
  }

  Sign specificCertainExprSign(SemExpr e) {
    containerSizeAccess(e) and
    (result = TPos() or result = TZero())
  }
}
