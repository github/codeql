/**
 * DEPRECATED: Use semmle.code.java.dataflow.ModulusAnalysis instead.
 *
 * Parity Analysis.
 *
 * The analysis is implemented as an abstract interpretation over the
 * two-valued domain `{even, odd}`.
 */

import java
private import SSA
private import RangeUtils
private import semmle.code.java.controlflow.Guards
private import SignAnalysis
private import semmle.code.java.Reflection

/** Gets an expression that is the remainder modulo 2 of `arg`. */
deprecated private Expr mod2(Expr arg) {
  exists(RemExpr rem |
    result = rem and
    arg = rem.getLeftOperand() and
    rem.getRightOperand().(CompileTimeConstantExpr).getIntValue() = 2
  )
  or
  result.(AndBitwiseExpr).hasOperands(arg, any(CompileTimeConstantExpr c | c.getIntValue() = 1))
  or
  result.(ParExpr).getExpr() = mod2(arg)
}

/** An expression that calculates remainder modulo 2. */
deprecated private class Mod2 extends Expr {
  Mod2() { this = mod2(_) }

  /** Gets the argument of this remainder operation. */
  Expr getArg() { this = mod2(result) }
}

/**
 * Parity represented as booleans. Even corresponds to `false` and odd
 * corresponds to `true`.
 */
deprecated class Parity extends boolean {
  Parity() { this = true or this = false }

  predicate isEven() { this = false }

  predicate isOdd() { this = true }
}

/**
 * Gets a condition that performs a parity check on `v`, such that `v` has
 * the given parity if the condition evaluates to `testIsTrue`.
 */
deprecated private Guard parityCheck(SsaVariable v, Parity parity, boolean testIsTrue) {
  exists(Mod2 rem, CompileTimeConstantExpr c, int r, boolean polarity |
    result.isEquality(rem, c, polarity) and
    c.getIntValue() = r and
    (r = 0 or r = 1) and
    rem.getArg() = v.getAUse() and
    (testIsTrue = true or testIsTrue = false) and
    (
      r = 0 and parity = testIsTrue.booleanXor(polarity)
      or
      r = 1 and parity = testIsTrue.booleanXor(polarity).booleanNot()
    )
  )
}

/**
 * Gets the parity of `e` if it can be directly determined.
 */
deprecated private Parity certainExprParity(Expr e) {
  exists(int i | e.(ConstantIntegerExpr).getIntValue() = i |
    if i % 2 = 0 then result.isEven() else result.isOdd()
  )
  or
  e.(LongLiteral).getValue().regexpMatch(".*[02468]") and result.isEven()
  or
  e.(LongLiteral).getValue().regexpMatch(".*[13579]") and result.isOdd()
  or
  not exists(e.(ConstantIntegerExpr).getIntValue()) and
  (
    result = certainExprParity(e.(ParExpr).getExpr())
    or
    exists(Guard guard, SsaVariable v, boolean testIsTrue |
      guard = parityCheck(v, result, testIsTrue) and
      e = v.getAUse() and
      guardControls_v2(guard, e.getBasicBlock(), testIsTrue)
    )
    or
    exists(SsaVariable arr, int arrlen, FieldAccess len |
      e = len and
      len.getField() instanceof ArrayLengthField and
      len.getQualifier() = arr.getAUse() and
      arr
          .(SsaExplicitUpdate)
          .getDefiningExpr()
          .(VariableAssign)
          .getSource()
          .(ArrayCreationExpr)
          .getFirstDimensionSize() = arrlen and
      if arrlen % 2 = 0 then result.isEven() else result.isOdd()
    )
  )
}

/**
 * Gets the expression that defines the array length that equals `len`, if any.
 */
deprecated private Expr arrLenDef(FieldAccess len) {
  exists(SsaVariable arr |
    len.getField() instanceof ArrayLengthField and
    len.getQualifier() = arr.getAUse() and
    arr
        .(SsaExplicitUpdate)
        .getDefiningExpr()
        .(VariableAssign)
        .getSource()
        .(ArrayCreationExpr)
        .getDimension(0) = result
  )
}

/** Gets a possible parity for `v`. */
deprecated private Parity ssaParity(SsaVariable v) {
  exists(VariableUpdate def | def = v.(SsaExplicitUpdate).getDefiningExpr() |
    result = exprParity(def.(VariableAssign).getSource())
    or
    exists(EnhancedForStmt for | def = for.getVariable()) and
    (result = true or result = false)
    or
    result = exprParity(def.(UnaryAssignExpr).getExpr()).booleanNot()
    or
    exists(AssignOp a | a = def and result = exprParity(a))
  )
  or
  result = fieldParity(v.(SsaImplicitUpdate).getSourceVariable().getVariable())
  or
  result = fieldParity(v.(SsaImplicitInit).getSourceVariable().getVariable())
  or
  exists(Parameter p |
    v.(SsaImplicitInit).isParameterDefinition(p) and
    (result = true or result = false)
  )
  or
  result = ssaParity(v.(SsaPhiNode).getAPhiInput())
}

/** Gets a possible parity for `f`. */
deprecated private Parity fieldParity(Field f) {
  result = exprParity(f.getAnAssignedValue())
  or
  exists(UnaryAssignExpr u |
    u.getExpr() = f.getAnAccess() and
    (result = true or result = false)
  )
  or
  exists(AssignOp a | a.getDest() = f.getAnAccess() | result = exprParity(a))
  or
  exists(ReflectiveFieldAccess rfa |
    rfa.inferAccessedField() = f and
    (result = true or result = false)
  )
  or
  if f.fromSource()
  then not exists(f.getInitializer()) and result.isEven()
  else (
    result = true or result = false
  )
}

/** Holds if the parity of `e` is too complicated to determine. */
deprecated private predicate unknownParity(Expr e) {
  e instanceof AssignDivExpr
  or
  e instanceof AssignRShiftExpr
  or
  e instanceof AssignURShiftExpr
  or
  e instanceof DivExpr
  or
  e instanceof RShiftExpr
  or
  e instanceof URShiftExpr
  or
  exists(Type fromtyp |
    e.(CastExpr).getExpr().getType() = fromtyp and not fromtyp instanceof IntegralType
  )
  or
  e instanceof ArrayAccess and e.getType() instanceof IntegralType
  or
  e instanceof MethodAccess and e.getType() instanceof IntegralType
  or
  e instanceof ClassInstanceExpr and e.getType() instanceof IntegralType
  or
  e.getType() instanceof FloatingPointType
  or
  e.getType() instanceof CharacterType
}

/** Gets a possible parity for `e`. */
deprecated private Parity exprParity(Expr e) {
  result = certainExprParity(e)
  or
  not exists(certainExprParity(e)) and
  (
    result = exprParity(e.(ParExpr).getExpr())
    or
    result = exprParity(arrLenDef(e))
    or
    exists(SsaVariable v | v.getAUse() = e | result = ssaParity(v)) and
    not exists(arrLenDef(e))
    or
    exists(FieldAccess fa | fa = e |
      not exists(SsaVariable v | v.getAUse() = fa) and
      not exists(arrLenDef(e)) and
      result = fieldParity(fa.getField())
    )
    or
    exists(VarAccess va | va = e |
      not exists(SsaVariable v | v.getAUse() = va) and
      not va instanceof FieldAccess and
      (result = true or result = false)
    )
    or
    result = exprParity(e.(AssignExpr).getSource())
    or
    result = exprParity(e.(PlusExpr).getExpr())
    or
    result = exprParity(e.(PostIncExpr).getExpr())
    or
    result = exprParity(e.(PostDecExpr).getExpr())
    or
    result = exprParity(e.(PreIncExpr).getExpr()).booleanNot()
    or
    result = exprParity(e.(PreDecExpr).getExpr()).booleanNot()
    or
    result = exprParity(e.(MinusExpr).getExpr())
    or
    result = exprParity(e.(BitNotExpr).getExpr()).booleanNot()
    or
    unknownParity(e) and
    (result = true or result = false)
    or
    exists(Parity p1, Parity p2, AssignOp a |
      a = e and
      p1 = exprParity(a.getDest()) and
      p2 = exprParity(a.getRhs())
    |
      a instanceof AssignAddExpr and result = p1.booleanXor(p2)
      or
      a instanceof AssignSubExpr and result = p1.booleanXor(p2)
      or
      a instanceof AssignMulExpr and result = p1.booleanAnd(p2)
      or
      a instanceof AssignRemExpr and
      (
        p2.isEven() and result = p1
        or
        p2.isOdd() and
        (result = true or result = false)
      )
      or
      a instanceof AssignAndExpr and result = p1.booleanAnd(p2)
      or
      a instanceof AssignOrExpr and result = p1.booleanOr(p2)
      or
      a instanceof AssignXorExpr and result = p1.booleanXor(p2)
      or
      a instanceof AssignLShiftExpr and
      (
        result.isEven()
        or
        result = p1 and not strictlyPositive(a.getRhs())
      )
    )
    or
    exists(Parity p1, Parity p2, BinaryExpr bin |
      bin = e and
      p1 = exprParity(bin.getLeftOperand()) and
      p2 = exprParity(bin.getRightOperand())
    |
      bin instanceof AddExpr and result = p1.booleanXor(p2)
      or
      bin instanceof SubExpr and result = p1.booleanXor(p2)
      or
      bin instanceof MulExpr and result = p1.booleanAnd(p2)
      or
      bin instanceof RemExpr and
      (
        p2.isEven() and result = p1
        or
        p2.isOdd() and
        (result = true or result = false)
      )
      or
      bin instanceof AndBitwiseExpr and result = p1.booleanAnd(p2)
      or
      bin instanceof OrBitwiseExpr and result = p1.booleanOr(p2)
      or
      bin instanceof XorBitwiseExpr and result = p1.booleanXor(p2)
      or
      bin instanceof LShiftExpr and
      (
        result.isEven()
        or
        result = p1 and not strictlyPositive(bin.getRightOperand())
      )
    )
    or
    result = exprParity(e.(ConditionalExpr).getTrueExpr())
    or
    result = exprParity(e.(ConditionalExpr).getFalseExpr())
    or
    result = exprParity(e.(CastExpr).getExpr())
  )
}

/**
 * Gets the parity of `e` if it can be uniquely determined.
 */
deprecated Parity getExprParity(Expr e) { result = exprParity(e) and 1 = count(exprParity(e)) }

/**
 * DEPRECATED: Use semmle.code.java.dataflow.ModulusAnalysis instead.
 *
 * Holds if the parity can be determined for both sides of `comp`. The boolean
 * `eqparity` indicates whether the two sides have equal or opposite parity.
 */
deprecated predicate parityComparison(ComparisonExpr comp, boolean eqparity) {
  exists(Expr left, Expr right, boolean lpar, boolean rpar |
    comp.getLeftOperand() = left and
    comp.getRightOperand() = right and
    lpar = getExprParity(left) and
    rpar = getExprParity(right) and
    eqparity = lpar.booleanXor(rpar).booleanNot()
  )
}
