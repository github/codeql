/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

private import SignAnalysisSpecific::Private
private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticGuard
private import semmle.code.java.semantic.SemanticSSA
private import semmle.code.java.semantic.SemanticType
private import semmle.code.java.dataflow.ConstantAnalysis
private import semmle.code.java.dataflow.RangeUtils
private import Sign

/** Gets the sign of `e` if this can be directly determined. */
private Sign certainExprSign(SemExpr e) {
  exists(int i | e.(SemConstantIntegerExpr).getIntValue() = i |
    i < 0 and result = TNeg()
    or
    i = 0 and result = TZero()
    or
    i > 0 and result = TPos()
  )
  or
  not exists(e.(SemConstantIntegerExpr).getIntValue()) and
  (
    exists(float f | f = e.(SemNumericLiteralExpr).getApproximateFloatValue() |
      f < 0 and result = TNeg()
      or
      f = 0 and result = TZero()
      or
      f > 0 and result = TPos()
    )
    or
    result = specificCertainExprSign(e)
  )
}

/** Holds if the sign of `e` is too complicated to determine. */
private predicate unknownSign(SemExpr e) {
  not exists(certainExprSign(e)) and
  (
    exists(SemIntegerLiteralExpr lit | lit = e and not exists(lit.getIntValue()))
    or
    exists(SemCastExpr cast, SemType fromtyp |
      cast = e and
      fromtyp = cast.getSemType() and
      not fromtyp instanceof SemNumericType
    )
    or
    numericExprWithUnknownSign(e)
  )
}

/**
 * Holds if `lowerbound` is a lower bound for `v` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate lowerBound(
  SemExpr lowerbound, SemSsaVariable v, SemSsaReadPosition pos, boolean isStrict
) {
  exists(boolean testIsTrue, SemComparisonExpr comp |
    pos.hasReadOfVar(v) and
    semGuardControlsSsaRead(semGetComparisonGuard(comp), pos, testIsTrue) and
    not unknownSign(lowerbound)
  |
    testIsTrue = true and
    comp.getLesserOperand() = lowerbound and
    comp.getGreaterOperand() = semSsaRead(v, 0) and
    (if comp.isStrict() then isStrict = true else isStrict = false)
    or
    testIsTrue = false and
    comp.getGreaterOperand() = lowerbound and
    comp.getLesserOperand() = semSsaRead(v, 0) and
    (if comp.isStrict() then isStrict = false else isStrict = true)
  )
}

/**
 * Holds if `upperbound` is an upper bound for `v` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate upperBound(
  SemExpr upperbound, SemSsaVariable v, SemSsaReadPosition pos, boolean isStrict
) {
  exists(boolean testIsTrue, SemComparisonExpr comp |
    pos.hasReadOfVar(v) and
    semGuardControlsSsaRead(semGetComparisonGuard(comp), pos, testIsTrue) and
    not unknownSign(upperbound)
  |
    testIsTrue = true and
    comp.getGreaterOperand() = upperbound and
    comp.getLesserOperand() = semSsaRead(v, 0) and
    (if comp.isStrict() then isStrict = true else isStrict = false)
    or
    testIsTrue = false and
    comp.getLesserOperand() = upperbound and
    comp.getGreaterOperand() = semSsaRead(v, 0) and
    (if comp.isStrict() then isStrict = false else isStrict = true)
  )
}

/**
 * Holds if `eqbound` is an equality/inequality for `v` at `pos`. This is
 * restricted to only include bounds for which we might determine a sign. The
 * boolean `isEq` gives the polarity:
 *  - `isEq = true` : `v = eqbound`
 *  - `isEq = false` : `v != eqbound`
 */
private predicate eqBound(SemExpr eqbound, SemSsaVariable v, SemSsaReadPosition pos, boolean isEq) {
  exists(SemGuard guard, boolean testIsTrue, boolean polarity |
    pos.hasReadOfVar(v) and
    semGuardControlsSsaRead(guard, pos, testIsTrue) and
    guard.isEquality(eqbound, semSsaRead(v, 0), polarity) and
    isEq = polarity.booleanXor(testIsTrue).booleanNot() and
    not unknownSign(eqbound)
  )
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be positive in
 * order for `v` to be positive.
 */
private predicate posBound(SemExpr bound, SemSsaVariable v, SemSsaReadPosition pos) {
  upperBound(bound, v, pos, _) or
  eqBound(bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be negative in
 * order for `v` to be negative.
 */
private predicate negBound(SemExpr bound, SemSsaVariable v, SemSsaReadPosition pos) {
  lowerBound(bound, v, pos, _) or
  eqBound(bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that can restrict whether `v`
 * can be zero.
 */
private predicate zeroBound(SemExpr bound, SemSsaVariable v, SemSsaReadPosition pos) {
  lowerBound(bound, v, pos, _) or
  upperBound(bound, v, pos, _) or
  eqBound(bound, v, pos, _)
}

/** Holds if `bound` allows `v` to be positive at `pos`. */
private predicate posBoundOk(SemExpr bound, SemSsaVariable v, SemSsaReadPosition pos) {
  posBound(bound, v, pos) and TPos() = semExprSign(bound)
}

/** Holds if `bound` allows `v` to be negative at `pos`. */
private predicate negBoundOk(SemExpr bound, SemSsaVariable v, SemSsaReadPosition pos) {
  negBound(bound, v, pos) and TNeg() = semExprSign(bound)
}

/** Holds if `bound` allows `v` to be zero at `pos`. */
private predicate zeroBoundOk(SemExpr bound, SemSsaVariable v, SemSsaReadPosition pos) {
  lowerBound(bound, v, pos, _) and TNeg() = semExprSign(bound)
  or
  lowerBound(bound, v, pos, false) and TZero() = semExprSign(bound)
  or
  upperBound(bound, v, pos, _) and TPos() = semExprSign(bound)
  or
  upperBound(bound, v, pos, false) and TZero() = semExprSign(bound)
  or
  eqBound(bound, v, pos, true) and TZero() = semExprSign(bound)
  or
  eqBound(bound, v, pos, false) and TZero() != semExprSign(bound)
}

/**
 * Holds if there is a bound that might restrict whether `v` has the sign `s`
 * at `pos`.
 */
private predicate hasGuard(SemSsaVariable v, SemSsaReadPosition pos, Sign s) {
  s = TPos() and posBound(_, v, pos)
  or
  s = TNeg() and negBound(_, v, pos)
  or
  s = TZero() and zeroBound(_, v, pos)
}

/**
 * Gets a possible sign of `v` at `pos` based on its definition, where the sign
 * might be ruled out by a guard.
 */
pragma[noinline]
private Sign guardedSsaSign(SemSsaVariable v, SemSsaReadPosition pos) {
  result = ssaDefSign(v) and
  pos.hasReadOfVar(v) and
  hasGuard(v, pos, result)
}

/**
 * Gets a possible sign of `v` at `pos` based on its definition, where no guard
 * can rule it out.
 */
pragma[noinline]
private Sign unguardedSsaSign(SemSsaVariable v, SemSsaReadPosition pos) {
  result = ssaDefSign(v) and
  pos.hasReadOfVar(v) and
  not hasGuard(v, pos, result)
}

/**
 * Gets a possible sign of `v` at read position `pos`, where a guard could have
 * ruled out the sign but does not.
 * This does not check that the definition of `v` also allows the sign.
 */
private Sign guardedSsaSignOk(SemSsaVariable v, SemSsaReadPosition pos) {
  result = TPos() and
  forex(SemExpr bound | posBound(bound, v, pos) | posBoundOk(bound, v, pos))
  or
  result = TNeg() and
  forex(SemExpr bound | negBound(bound, v, pos) | negBoundOk(bound, v, pos))
  or
  result = TZero() and
  forex(SemExpr bound | zeroBound(bound, v, pos) | zeroBoundOk(bound, v, pos))
}

/** Gets a possible sign for `v` at `pos`. */
private Sign ssaSign(SemSsaVariable v, SemSsaReadPosition pos) {
  result = unguardedSsaSign(v, pos)
  or
  result = guardedSsaSign(v, pos) and
  result = guardedSsaSignOk(v, pos)
}

/** Gets a possible sign for `v`. */
pragma[nomagic]
private Sign ssaDefSign(SemSsaVariable v) {
  result = explicitSsaDefSign(v)
  or
  result = implicitSsaDefSign(v)
  or
  exists(SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge |
    v = phi and
    edge.phiInput(phi, inp) and
    result = ssaSign(inp, edge)
  )
}

/** Returns the sign of explicit SSA definition `v`. */
private Sign explicitSsaDefSign(SemSsaVariable v) {
  exists(SemVariableUpdate def | def = getExplicitSsaAssignment(v) |
    result = semExprSign(getExprFromSsaAssignment(def))
    or
    anySign(result) and explicitSsaDefWithAnySign(def)
    or
    result = semExprSign(def.(SemIncrementExpr).getExpr()).inc()
    or
    result = semExprSign(def.(SemDecrementExpr).getExpr()).dec()
  )
}

/** Gets a possible sign for `e`. */
cached
Sign semExprSign(SemExpr e) {
  exists(Sign s |
    // We know exactly what the sign is. This handles constants, collection sizes, etc.
    s = certainExprSign(e)
    or
    not exists(certainExprSign(e)) and
    (
      // We'll never know what the sign is.
      anySign(s) and unknownSign(e)
      or
      // Propagate via SSA
      exists(SemSsaVariable v | v.getAUse() = e |
        // Propagate the sign from the def of `v`, incorporating any inference from guards.
        s = ssaSign(v, any(SemSsaReadPositionBlock bb | bb.getAnExpr() = e))
        or
        // No block for this read. Just use the sign of the def.
        // REVIEW: How can this happen?
        not exists(SemSsaReadPositionBlock bb | bb.getAnExpr() = e) and
        s = ssaDefSign(v)
      )
      or
      // A variable access without an SSA definition. Let the language give us any constraints it
      // can.
      exists(SemVarAccess access | access = e |
        not exists(SemSsaVariable v | v.getAUse() = access) and
        s = getVarAccessSign(access)
      )
      or
      s = specificSubExprSign(e)
    )
  |
    if e.getSemType() instanceof SemUnsignedIntegerType and s = TNeg()
    then result = TPos()
    else result = s
  )
}

/** Gets a possible sign for `e` from the signs of its child nodes. */
private Sign specificSubExprSign(SemExpr e) {
  result = semExprSign(getASubExprWithSameSign(e))
  or
  exists(SemDivExpr div | div = e |
    result = semExprSign(div.getLeftOperand()) and
    result != TZero() and
    div.getRightOperand().(SemFloatingPointLiteralExpr).getFloatValue() = 0
  )
  or
  exists(UnaryOperation unary | unary = e |
    result = semExprSign(unary.getOperand()).applyUnaryOp(unary.getOp())
  )
  or
  exists(Sign s1, Sign s2 | binaryOpSigns(e, s1, s2) |
    result = s1.applyBinaryOp(s2, e.(BinaryOperation).getOp())
  )
}

pragma[noinline]
private predicate binaryOpSigns(SemExpr e, Sign lhs, Sign rhs) {
  lhs = binaryOpLhsSign(e) and
  rhs = binaryOpRhsSign(e)
}

private Sign binaryOpLhsSign(BinaryOperation e) { result = semExprSign(e.getLeftOperand()) }

private Sign binaryOpRhsSign(BinaryOperation e) { result = semExprSign(e.getRightOperand()) }

/**
 * Dummy predicate that holds for any sign. This is added to improve readability
 * of cases where the sign is unrestricted.
 */
predicate anySign(Sign s) { any() }

/** Holds if `e` can be positive and cannot be negative. */
predicate semPositive(SemExpr e) {
  semExprSign(e) = TPos() and
  not semExprSign(e) = TNeg()
}

/** Holds if `e` can be negative and cannot be positive. */
predicate semNegative(SemExpr e) {
  semExprSign(e) = TNeg() and
  not semExprSign(e) = TPos()
}

/** Holds if `e` is strictly positive. */
predicate semStrictlyPositive(SemExpr e) {
  semExprSign(e) = TPos() and
  not semExprSign(e) = TNeg() and
  not semExprSign(e) = TZero()
}

/** Holds if `e` is strictly negative. */
predicate semStrictlyNegative(SemExpr e) {
  semExprSign(e) = TNeg() and
  not semExprSign(e) = TPos() and
  not semExprSign(e) = TZero()
}

private module Java {
  private import java

  predicate positive(Expr e) { semPositive(getSemanticExpr(e)) }

  predicate negative(Expr e) { semNegative(getSemanticExpr(e)) }

  predicate strictlyPositive(Expr e) { semStrictlyPositive(getSemanticExpr(e)) }

  predicate strictlyNegative(Expr e) { semStrictlyNegative(getSemanticExpr(e)) }
}

import Java
