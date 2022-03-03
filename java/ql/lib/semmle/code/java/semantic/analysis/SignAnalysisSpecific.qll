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
  private import semmle.code.java.semantic.SemanticExprSpecific
  private import semmle.code.java.semantic.SemanticGuard
  private import semmle.code.java.semantic.SemanticSSA

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

  Sign languageExprSign(SemExpr e) {
    exists(VarAccess access | access = getJavaExpr(e) |
      not exists(SsaVariable v | v.getAUse() = access) and
      (
        result = fieldSign(getField(access.(FieldAccess)))
        or
        semAnySign(result) and not access instanceof FieldAccess
      )
    )
  }

  predicate ignoreExprSign(SemExpr e) { getJavaExpr(e) instanceof LocalVariableDeclExpr }

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
      or
      exists(CastExpr cast | cast = expr |
        // TODO: Stop tracking the result if the _result_ is not numeric.
        not cast.getExpr().getType() instanceof NumericOrCharType
      )
    )
  }

  /** Holds if `def` can have any sign. */
  predicate explicitSsaDefWithAnySign(SemSsaExplicitUpdate def) {
    exists(EnhancedForStmt for |
      getJavaSsaVariable(def).(SsaExplicitUpdate).getDefiningExpr() = for.getVariable()
    )
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
      semAnySign(result) and nonFieldImplicitSsaDefinition(javaVariable)
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
    else semAnySign(result)
  }

  /** Returned an expression that is assigned to `f`. */
  private SemExpr getAssignedValueToField(Field f) {
    result = getSemanticExpr(f.getAnAssignedValue()) or
    result = getSemanticExpr(any(AssignOp a | a.getDest() = f.getAnAccess()))
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
          else semAnySign(result)
  }

  /** Returns a sub expression of `e` for expression types where the sign depends on the child. */
  SemExpr getASubExprWithSameSign(SemExpr e) {
    result = e.(SemCopyValueExpr).getOperand() or
    result = getSemanticExpr(getJavaExpr(e).(ChooseExpr).getAResultExpr()) or
    result = e.(SemConvertExpr).getOperand() or
    result = getSemanticExpr(getJavaExpr(e).(CastExpr).getExpr()) // REVIEW: Should only apply to trackable operations
  }

  private Field getField(FieldAccess fa) { result = fa.getField() }

  Sign getLoadSign(SemLoadExpr access) {
    result = fieldSign(getField(getJavaExpr(access).(FieldAccess)))
    or
    semAnySign(result) and not getJavaExpr(access) instanceof FieldAccess
  }

  Sign specificCertainExprSign(SemExpr e) {
    containerSizeAccess(e) and
    (result = TPos() or result = TZero())
  }
}
