/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

private import SignAnalysisSpecific::Private
private import SsaReadPositionCommon
private import Sign

/** Gets the sign of `e` if this can be directly determined. */
Sign certainExprSign(Expr e) {
  exists(int i | e.(ConstantIntegerExpr).getIntValue() = i |
    i < 0 and result = TNeg()
    or
    i = 0 and result = TZero()
    or
    i > 0 and result = TPos()
  )
  or
  not exists(e.(ConstantIntegerExpr).getIntValue()) and
  (
    exists(float f | f = getNonIntegerValue(e) |
      f < 0 and result = TNeg()
      or
      f = 0 and result = TZero()
      or
      f > 0 and result = TPos()
    )
    or
    exists(string charlit | charlit = getCharValue(e) |
      if charlit.regexpMatch("\\u0000") then result = TZero() else result = TPos()
    )
    or
    containerSizeAccess(e) and
    (result = TPos() or result = TZero())
    or
    positiveExpression(e) and result = TPos()
  )
}

/** Holds if the sign of `e` is too complicated to determine. */
predicate unknownSign(Expr e) {
  not exists(certainExprSign(e)) and
  (
    exists(IntegerLiteral lit | lit = e and not exists(lit.getValue().toInt()))
    or
    exists(LongLiteral lit | lit = e and not exists(lit.getValue().toFloat()))
    or
    exists(CastExpr cast, Type fromtyp |
      cast = e and
      fromtyp = cast.getExpr().getType() and
      not fromtyp instanceof NumericOrCharType
    )
    or
    unknownIntegerAccess(e)
  )
}

/**
 * Holds if `lowerbound` is a lower bound for `v` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate lowerBound(Expr lowerbound, SsaVariable v, SsaReadPosition pos, boolean isStrict) {
  exists(boolean testIsTrue, ComparisonExpr comp |
    pos.hasReadOfVar(v) and
    guardControlsSsaRead(getComparisonGuard(comp), pos, testIsTrue) and
    not unknownSign(lowerbound)
  |
    testIsTrue = true and
    comp.getLesserOperand() = lowerbound and
    comp.getGreaterOperand() = ssaRead(v, 0) and
    (if comp.isStrict() then isStrict = true else isStrict = false)
    or
    testIsTrue = false and
    comp.getGreaterOperand() = lowerbound and
    comp.getLesserOperand() = ssaRead(v, 0) and
    (if comp.isStrict() then isStrict = false else isStrict = true)
  )
}

/**
 * Holds if `upperbound` is an upper bound for `v` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate upperBound(Expr upperbound, SsaVariable v, SsaReadPosition pos, boolean isStrict) {
  exists(boolean testIsTrue, ComparisonExpr comp |
    pos.hasReadOfVar(v) and
    guardControlsSsaRead(getComparisonGuard(comp), pos, testIsTrue) and
    not unknownSign(upperbound)
  |
    testIsTrue = true and
    comp.getGreaterOperand() = upperbound and
    comp.getLesserOperand() = ssaRead(v, 0) and
    (if comp.isStrict() then isStrict = true else isStrict = false)
    or
    testIsTrue = false and
    comp.getLesserOperand() = upperbound and
    comp.getGreaterOperand() = ssaRead(v, 0) and
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
private predicate eqBound(Expr eqbound, SsaVariable v, SsaReadPosition pos, boolean isEq) {
  exists(Guard guard, boolean testIsTrue, boolean polarity |
    pos.hasReadOfVar(v) and
    guardControlsSsaRead(guard, pos, testIsTrue) and
    guard.isEquality(eqbound, ssaRead(v, 0), polarity) and
    isEq = polarity.booleanXor(testIsTrue).booleanNot() and
    not unknownSign(eqbound)
  )
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be positive in
 * order for `v` to be positive.
 */
private predicate posBound(Expr bound, SsaVariable v, SsaReadPosition pos) {
  upperBound(bound, v, pos, _) or
  eqBound(bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that needs to be negative in
 * order for `v` to be negative.
 */
private predicate negBound(Expr bound, SsaVariable v, SsaReadPosition pos) {
  lowerBound(bound, v, pos, _) or
  eqBound(bound, v, pos, true)
}

/**
 * Holds if `bound` is a bound for `v` at `pos` that can restrict whether `v`
 * can be zero.
 */
private predicate zeroBound(Expr bound, SsaVariable v, SsaReadPosition pos) {
  lowerBound(bound, v, pos, _) or
  upperBound(bound, v, pos, _) or
  eqBound(bound, v, pos, _)
}

/** Holds if `bound` allows `v` to be positive at `pos`. */
private predicate posBoundOk(Expr bound, SsaVariable v, SsaReadPosition pos) {
  posBound(bound, v, pos) and TPos() = exprSign(bound)
}

/** Holds if `bound` allows `v` to be negative at `pos`. */
private predicate negBoundOk(Expr bound, SsaVariable v, SsaReadPosition pos) {
  negBound(bound, v, pos) and TNeg() = exprSign(bound)
}

/** Holds if `bound` allows `v` to be zero at `pos`. */
private predicate zeroBoundOk(Expr bound, SsaVariable v, SsaReadPosition pos) {
  lowerBound(bound, v, pos, _) and TNeg() = exprSign(bound)
  or
  lowerBound(bound, v, pos, false) and TZero() = exprSign(bound)
  or
  upperBound(bound, v, pos, _) and TPos() = exprSign(bound)
  or
  upperBound(bound, v, pos, false) and TZero() = exprSign(bound)
  or
  eqBound(bound, v, pos, true) and TZero() = exprSign(bound)
  or
  eqBound(bound, v, pos, false) and TZero() != exprSign(bound)
}

/**
 * Holds if there is a bound that might restrict whether `v` has the sign `s`
 * at `pos`.
 */
private predicate hasGuard(SsaVariable v, SsaReadPosition pos, Sign s) {
  s = TPos() and posBound(_, v, pos)
  or
  s = TNeg() and negBound(_, v, pos)
  or
  s = TZero() and zeroBound(_, v, pos)
}

pragma[noinline]
private Sign guardedSsaSign(SsaVariable v, SsaReadPosition pos) {
  // SSA variable can have sign `result`
  result = ssaDefSign(v) and
  pos.hasReadOfVar(v) and
  // there are guards at this position on `v` that might restrict it to be sign `result`.
  // (So we need to check if they are satisfied)
  hasGuard(v, pos, result)
}

pragma[noinline]
private Sign unguardedSsaSign(SsaVariable v, SsaReadPosition pos) {
  // SSA variable can have sign `result`
  result = ssaDefSign(v) and
  pos.hasReadOfVar(v) and
  // there's no guard at this position on `v` that might restrict it to be sign `result`.
  not hasGuard(v, pos, result)
}

/**
 * Gets the sign of `v` at read position `pos`, when there's at least one guard
 * on `v` at position `pos`. Each bound corresponding to a given sign must be met
 * in order for `v` to be of that sign.
 */
private Sign guardedSsaSignOk(SsaVariable v, SsaReadPosition pos) {
  result = TPos() and
  forex(Expr bound | posBound(bound, v, pos) | posBoundOk(bound, v, pos))
  or
  result = TNeg() and
  forex(Expr bound | negBound(bound, v, pos) | negBoundOk(bound, v, pos))
  or
  result = TZero() and
  forex(Expr bound | zeroBound(bound, v, pos) | zeroBoundOk(bound, v, pos))
}

/** Gets a possible sign for `v` at `pos`. */
Sign ssaSign(SsaVariable v, SsaReadPosition pos) {
  result = unguardedSsaSign(v, pos)
  or
  result = guardedSsaSign(v, pos) and
  result = guardedSsaSignOk(v, pos)
}

/** Gets a possible sign for `v`. */
pragma[nomagic]
Sign ssaDefSign(SsaVariable v) {
  result = explicitSsaDefSign(v)
  or
  result = implicitSsaDefSign(v)
  or
  exists(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge |
    v = phi and
    edge.phiInput(phi, inp) and
    result = ssaSign(inp, edge)
  )
}

/** Gets a possible sign for `e`. */
cached
Sign exprSign(Expr e) {
  result = certainExprSign(e)
  or
  not exists(certainExprSign(e)) and
  (
    unknownSign(e)
    or
    exists(SsaVariable v | getARead(v) = e | result = ssaVariableSign(v, e))
    or
    e =
      any(VarAccess access |
        not exists(SsaVariable v | getARead(v) = access) and
        (
          result = fieldSign(getField(access.(FieldAccess))) or
          not access instanceof FieldAccess
        )
      )
    or
    result = specificSubExprSign(e)
  )
}

/** Holds if `e` can be positive and cannot be negative. */
predicate positive(Expr e) {
  exprSign(e) = TPos() and
  not exprSign(e) = TNeg()
}

/** Holds if `e` can be negative and cannot be positive. */
predicate negative(Expr e) {
  exprSign(e) = TNeg() and
  not exprSign(e) = TPos()
}

/** Holds if `e` is strictly positive. */
predicate strictlyPositive(Expr e) {
  exprSign(e) = TPos() and
  not exprSign(e) = TNeg() and
  not exprSign(e) = TZero()
}

/** Holds if `e` is strictly negative. */
predicate strictlyNegative(Expr e) {
  exprSign(e) = TNeg() and
  not exprSign(e) = TPos() and
  not exprSign(e) = TZero()
}
