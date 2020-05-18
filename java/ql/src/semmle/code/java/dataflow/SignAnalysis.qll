/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

import java
private import SSA
private import RangeUtils
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.Reflection
private import semmle.code.java.Collections
private import semmle.code.java.Maps

private newtype TSign =
  TNeg() or
  TZero() or
  TPos()

private class Sign extends TSign {
  string toString() {
    result = "-" and this = TNeg()
    or
    result = "0" and this = TZero()
    or
    result = "+" and this = TPos()
  }

  Sign inc() {
    this = TNeg() and result = TNeg()
    or
    this = TNeg() and result = TZero()
    or
    this = TZero() and result = TPos()
    or
    this = TPos() and result = TPos()
  }

  Sign dec() { result.inc() = this }

  Sign neg() {
    this = TNeg() and result = TPos()
    or
    this = TZero() and result = TZero()
    or
    this = TPos() and result = TNeg()
  }

  Sign bitnot() {
    this = TNeg() and result = TPos()
    or
    this = TNeg() and result = TZero()
    or
    this = TZero() and result = TNeg()
    or
    this = TPos() and result = TNeg()
  }

  Sign add(Sign s) {
    this = TZero() and result = s
    or
    s = TZero() and result = this
    or
    this = s and this = result
    or
    this = TPos() and s = TNeg()
    or
    this = TNeg() and s = TPos()
  }

  Sign mul(Sign s) {
    result = TZero() and this = TZero()
    or
    result = TZero() and s = TZero()
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  Sign div(Sign s) {
    result = TZero() and s = TNeg()
    or
    result = TZero() and s = TPos()
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  Sign rem(Sign s) {
    result = TZero() and s = TNeg()
    or
    result = TZero() and s = TPos()
    or
    result = this and s = TNeg()
    or
    result = this and s = TPos()
  }

  Sign bitand(Sign s) {
    result = TZero() and this = TZero()
    or
    result = TZero() and s = TZero()
    or
    result = TZero() and this = TPos()
    or
    result = TZero() and s = TPos()
    or
    result = TNeg() and this = TNeg() and s = TNeg()
    or
    result = TPos() and this = TNeg() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TNeg()
    or
    result = TPos() and this = TPos() and s = TPos()
  }

  Sign bitor(Sign s) {
    result = TZero() and this = TZero() and s = TZero()
    or
    result = TNeg() and this = TNeg()
    or
    result = TNeg() and s = TNeg()
    or
    result = TPos() and this = TPos() and s = TZero()
    or
    result = TPos() and this = TZero() and s = TPos()
    or
    result = TPos() and this = TPos() and s = TPos()
  }

  Sign bitxor(Sign s) {
    result = TZero() and this = s
    or
    result = this and s = TZero()
    or
    result = s and this = TZero()
    or
    result = TPos() and this = TPos() and s = TPos()
    or
    result = TNeg() and this = TNeg() and s = TPos()
    or
    result = TNeg() and this = TPos() and s = TNeg()
    or
    result = TPos() and this = TNeg() and s = TNeg()
  }

  Sign lshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    this != TZero() and s != TZero()
  }

  Sign rshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    result = TNeg() and this = TNeg()
    or
    result != TNeg() and this = TPos() and s != TZero()
  }

  Sign urshift(Sign s) {
    result = TZero() and this = TZero()
    or
    result = this and s = TZero()
    or
    result != TZero() and this = TNeg() and s != TZero()
    or
    result != TNeg() and this = TPos() and s != TZero()
  }
}

/** Gets the sign of `e` if this can be directly determined. */
private Sign certainExprSign(Expr e) {
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
    exists(float f |
      f = e.(LongLiteral).getValue().toFloat() or
      f = e.(FloatingPointLiteral).getValue().toFloat() or
      f = e.(DoubleLiteral).getValue().toFloat()
    |
      f < 0 and result = TNeg()
      or
      f = 0 and result = TZero()
      or
      f > 0 and result = TPos()
    )
    or
    exists(string charlit | charlit = e.(CharacterLiteral).getValue() |
      if charlit = "\\0" or charlit = "\\u0000" then result = TZero() else result = TPos()
    )
    or
    e.(MethodAccess).getMethod() instanceof StringLengthMethod and
    (result = TPos() or result = TZero())
    or
    e.(MethodAccess).getMethod() instanceof CollectionSizeMethod and
    (result = TPos() or result = TZero())
    or
    e.(MethodAccess).getMethod() instanceof MapSizeMethod and
    (result = TPos() or result = TZero())
  )
}

/** Holds if the sign of `e` is too complicated to determine. */
private predicate unknownSign(Expr e) {
  not exists(e.(ConstantIntegerExpr).getIntValue()) and
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
    e instanceof ArrayAccess and e.getType() instanceof NumericOrCharType
    or
    e instanceof MethodAccess and e.getType() instanceof NumericOrCharType
    or
    e instanceof ClassInstanceExpr and e.getType() instanceof NumericOrCharType
  )
}

/**
 * Holds if `lowerbound` is a lower bound for `v` at `pos`. This is restricted
 * to only include bounds for which we might determine a sign.
 */
private predicate lowerBound(Expr lowerbound, SsaVariable v, SsaReadPosition pos, boolean isStrict) {
  exists(boolean testIsTrue, ComparisonExpr comp |
    pos.hasReadOfVar(v) and
    guardControlsSsaRead(comp, pos, testIsTrue) and
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
    guardControlsSsaRead(comp, pos, testIsTrue) and
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
  result = ssaDefSign(v) and
  pos.hasReadOfVar(v) and
  hasGuard(v, pos, result)
}

pragma[noinline]
private Sign unguardedSsaSign(SsaVariable v, SsaReadPosition pos) {
  result = ssaDefSign(v) and
  pos.hasReadOfVar(v) and
  not hasGuard(v, pos, result)
}

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
private Sign ssaSign(SsaVariable v, SsaReadPosition pos) {
  result = unguardedSsaSign(v, pos)
  or
  result = guardedSsaSign(v, pos) and
  result = guardedSsaSignOk(v, pos)
}

/** Gets a possible sign for `v`. */
pragma[nomagic]
private Sign ssaDefSign(SsaVariable v) {
  exists(VariableUpdate def | def = v.(SsaExplicitUpdate).getDefiningExpr() |
    result = exprSign(def.(VariableAssign).getSource())
    or
    exists(EnhancedForStmt for | def = for.getVariable())
    or
    result = exprSign(def.(PostIncExpr).getExpr()).inc()
    or
    result = exprSign(def.(PreIncExpr).getExpr()).inc()
    or
    result = exprSign(def.(PostDecExpr).getExpr()).dec()
    or
    result = exprSign(def.(PreDecExpr).getExpr()).dec()
    or
    exists(AssignOp a | a = def and result = exprSign(a))
  )
  or
  result = fieldSign(v.(SsaImplicitUpdate).getSourceVariable().getVariable())
  or
  result = fieldSign(v.(SsaImplicitInit).getSourceVariable().getVariable())
  or
  exists(Parameter p | v.(SsaImplicitInit).isParameterDefinition(p))
  or
  exists(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge |
    v = phi and
    edge.phiInput(phi, inp) and
    result = ssaSign(inp, edge)
  )
}

/** Gets a possible sign for `f`. */
private Sign fieldSign(Field f) {
  result = exprSign(f.getAnAssignedValue())
  or
  exists(PostIncExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).inc())
  or
  exists(PreIncExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).inc())
  or
  exists(PostDecExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).dec())
  or
  exists(PreDecExpr inc | inc.getExpr() = f.getAnAccess() and result = fieldSign(f).dec())
  or
  exists(AssignOp a | a.getDest() = f.getAnAccess() | result = exprSign(a))
  or
  exists(ReflectiveFieldAccess rfa | rfa.inferAccessedField() = f)
  or
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
        else any()
}

/** Gets a possible sign for `e`. */
cached
private Sign exprSign(Expr e) {
  result = certainExprSign(e)
  or
  not exists(certainExprSign(e)) and
  (
    unknownSign(e)
    or
    exists(SsaVariable v | v.getAUse() = e |
      result = ssaSign(v, any(SsaReadPositionBlock bb | bb.getBlock() = e.getBasicBlock()))
      or
      not exists(e.getBasicBlock()) and result = ssaDefSign(v)
    )
    or
    exists(FieldAccess fa | fa = e |
      not exists(SsaVariable v | v.getAUse() = fa) and
      result = fieldSign(fa.getField())
    )
    or
    exists(VarAccess va | va = e |
      not exists(SsaVariable v | v.getAUse() = va) and
      not va instanceof FieldAccess
    )
    or
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
  )
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
