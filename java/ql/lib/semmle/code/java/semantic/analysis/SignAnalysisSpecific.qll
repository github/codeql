/**
 * Provides Java-specific definitions for use in sign analysis.
 */

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
 * An access to the size of a container (`string`, `Map`, or `Collection`).
 *
 * The sign of the size of a container is never negative.
 */
private class ContainerSizeAccess extends CustomSignExpr {
  ContainerSizeAccess() {
    exists(Method method | method = getJavaExpr(this).(MethodAccess).getMethod() |
      method instanceof StringLengthMethod
      or
      method instanceof CollectionSizeMethod
      or
      method instanceof MapSizeMethod
    )
  }

  override Sign getSignRestriction() { result = TPos() or result = TZero() }
}

/**
 * A field access that is not connected to an SSA definition.
 *
 * The sign of the field access is the union of the signs of all values every assigned to that
 * field.
 */
private class FieldSign extends CustomSignExpr {
  FieldAccess access;

  FieldSign() {
    (this instanceof SemNonSsaLoadExpr or this.(SemExpr).getOpcode() instanceof Opcode::Unknown) and
    access = getJavaExpr(this)
  }

  override Sign getSignRestriction() { result = fieldSign(getField(access.(FieldAccess))) }
}

/** Gets the variable underlying the implicit SSA variable `v`. */
private Variable getImplicitSsaDeclaration(SsaVariable v) {
  result = v.(SsaImplicitUpdate).getSourceVariable().getVariable() or
  result = v.(SsaImplicitInit).getSourceVariable().getVariable()
}

/**
 * A definition of a field, without a source expression.
 *
 * The sign of such a definition is the union of the signs of all values ever stored to that field.
 */
private class FieldSignDef extends CustomSignDef {
  Field field;

  FieldSignDef() { field = getImplicitSsaDeclaration(getJavaSsaVariable(this)) }

  override Sign getSign() { result = fieldSign(field) }
}

/** The SSA definition that initializes a parameter on entry to a function. */
private class ParameterSignDef extends CustomSignDef {
  ParameterSignDef() {
    exists(Parameter p | getJavaSsaVariable(this).(SsaImplicitInit).isParameterDefinition(p))
  }

  final override Sign getSign() { semAnySign(result) }
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

/** A switch expression or ternary expression. */
private class ChooseSignExpr extends CustomSignExpr {
  ChooseExpr choose;

  ChooseSignExpr() { choose = getJavaExpr(this) }

  override Sign getSignRestriction() {
    result = semExprSign(getSemanticExpr(choose.getAResultExpr()))
  }
}

/** A Java cast expression. */
private class CastSignExpr extends CustomSignExpr {
  CastExpr cast;

  CastSignExpr() {
    // The core already handles numeric conversions, boxing, and unboxing.
    // We need to handle any casts between reference types that we want to track
    // here.
    cast = getJavaExpr(this) and
    cast.getType() instanceof RefType and
    cast.getExpr().getType() instanceof RefType
  }

  override Sign getSignRestriction() {
    result = semExprSign(getSemanticExpr(cast.getExpr()))
    or
    semAnySign(result) and not cast.getExpr().getType() instanceof NumericOrCharType
  }
}

private Field getField(FieldAccess fa) { result = fa.getField() }

/**
 * Workaround to allow certain expressions to have a negative sign, even if the type of the
 * expression is unsigned.
 */
predicate ignoreTypeRestrictions(SemExpr e) {
  // REVIEW: Only needed to match original Java results.
  e = getEnhancedForInitExpr(_)
}

/**
 * Workaround to track the sign of cetain expressions even if the type of the expression is not
 * numeric.
 */
predicate trackUnknownNonNumericExpr(SemExpr e) {
  // REVIEW: Only needed to match original Java results.
  e = getEnhancedForInitExpr(_) or
  getJavaExpr(e) instanceof VarAccess or
  getJavaExpr(e) instanceof CastExpr
}

/**
 * Workaround to ignore tracking of certain expressions even if the type of the expression is
 * numeric.
 */
predicate ignoreExprSign(SemExpr e) {
  // REVIEW: Only needed to match original Java results.
  getJavaExpr(e) instanceof LocalVariableDeclExpr or getJavaExpr(e) instanceof TypeAccess
}
