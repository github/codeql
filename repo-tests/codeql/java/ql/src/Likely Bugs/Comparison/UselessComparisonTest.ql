/**
 * @name Useless comparison test
 * @description A comparison operation that always evaluates to true or always
 *              evaluates to false may indicate faulty logic and may result in
 *              dead code.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/constant-comparison
 * @tags correctness
 *       logic
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 */

import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.SSA
import semmle.code.java.dataflow.SignAnalysis
import semmle.code.java.dataflow.RangeAnalysis

/** Holds if `cond` always evaluates to `isTrue`. */
predicate constCond(BinaryExpr cond, boolean isTrue, Reason reason) {
  exists(
    ComparisonExpr comp, Expr lesser, Expr greater, Bound b, int d1, int d2, Reason r1, Reason r2
  |
    comp = cond and
    lesser = comp.getLesserOperand() and
    greater = comp.getGreaterOperand() and
    bounded(lesser, b, d1, isTrue, r1) and
    bounded(greater, b, d2, isTrue.booleanNot(), r2) and
    (reason = r1 or reason = r2) and
    (
      r1 instanceof NoReason and r2 instanceof NoReason
      or
      not reason instanceof NoReason
    )
  |
    isTrue = true and comp.isStrict() and d1 < d2
    or
    isTrue = true and not comp.isStrict() and d1 <= d2
    or
    isTrue = false and comp.isStrict() and d1 >= d2
    or
    isTrue = false and not comp.isStrict() and d1 > d2
  )
  or
  exists(EqualityTest eq, Expr lhs, Expr rhs |
    eq = cond and
    lhs = eq.getLeftOperand() and
    rhs = eq.getRightOperand()
  |
    exists(Bound b, int d1, int d2, boolean upper, Reason r1, Reason r2 |
      bounded(lhs, b, d1, upper, r1) and
      bounded(rhs, b, d2, upper.booleanNot(), r2) and
      isTrue = eq.polarity().booleanNot() and
      (reason = r1 or reason = r2) and
      (
        r1 instanceof NoReason and r2 instanceof NoReason
        or
        not reason instanceof NoReason
      )
    |
      upper = true and d1 < d2 // lhs <= b + d1 < b + d2 <= rhs
      or
      upper = false and d1 > d2 // lhs >= b + d1 > b + d2 >= rhs
    )
    or
    exists(Bound b, int d, Reason r1, Reason r2, Reason r3, Reason r4 |
      bounded(lhs, b, d, true, r1) and
      bounded(lhs, b, d, false, r2) and
      bounded(rhs, b, d, true, r3) and
      bounded(rhs, b, d, false, r4) and
      isTrue = eq.polarity()
    |
      (reason = r1 or reason = r2 or reason = r3 or reason = r4) and
      (
        r1 instanceof NoReason and
        r2 instanceof NoReason and
        r3 instanceof NoReason and
        r4 instanceof NoReason
        or
        not reason instanceof NoReason
      )
    )
  )
}

/** Holds if `cond` always evaluates to `isTrue`. */
predicate constCondSimple(BinaryExpr cond, boolean isTrue) {
  constCond(cond, isTrue, any(NoReason nr))
}

/** Gets a seemingly positive expression that might be negative due to overflow. */
Expr overFlowCand() {
  exists(BinaryExpr bin |
    result = bin and
    positive(bin.getLeftOperand()) and
    positive(bin.getRightOperand())
  |
    bin instanceof AddExpr or
    bin instanceof MulExpr or
    bin instanceof LShiftExpr
  )
  or
  exists(AssignOp op |
    result = op and
    positive(op.getDest()) and
    positive(op.getRhs())
  |
    op instanceof AssignAddExpr or
    op instanceof AssignMulExpr or
    op instanceof AssignLShiftExpr
  )
  or
  exists(AddExpr add, CompileTimeConstantExpr c |
    result = add and
    add.hasOperands(overFlowCand(), c) and
    c.getIntValue() >= 0
  )
  or
  exists(AssignAddExpr add, CompileTimeConstantExpr c |
    result = add and
    add.getDest() = overFlowCand() and
    add.getRhs() = c and
    c.getIntValue() >= 0
  )
  or
  exists(SsaExplicitUpdate x | result = x.getAUse() and x.getDefiningExpr() = overFlowCand())
  or
  result.(AssignExpr).getRhs() = overFlowCand()
  or
  result.(LocalVariableDeclExpr).getInit() = overFlowCand()
  or
  exists(ConditionalExpr c | c = result |
    c.getTrueExpr() = overFlowCand() and
    c.getFalseExpr() = overFlowCand()
  )
}

predicate positiveOrNegative(Expr e) { positive(e) or negative(e) }

/** Gets an expression that equals `v` plus a positive or negative value. */
Expr increaseOrDecreaseOfVar(SsaVariable v) {
  exists(AssignAddExpr add |
    result = add and
    positiveOrNegative(add.getDest()) and
    add.getRhs() = v.getAUse()
  )
  or
  exists(AddExpr add, Expr e |
    result = add and
    add.hasOperands(v.getAUse(), e) and
    positiveOrNegative(e)
  )
  or
  exists(SubExpr sub |
    result = sub and
    sub.getLeftOperand() = v.getAUse() and
    positiveOrNegative(sub.getRightOperand())
  )
  or
  exists(SsaExplicitUpdate x |
    result = x.getAUse() and x.getDefiningExpr() = increaseOrDecreaseOfVar(v)
  )
  or
  result.(AssignExpr).getRhs() = increaseOrDecreaseOfVar(v)
  or
  result.(LocalVariableDeclExpr).getInit() = increaseOrDecreaseOfVar(v)
}

predicate overFlowTest(ComparisonExpr comp) {
  (
    exists(SsaVariable v | comp.hasOperands(increaseOrDecreaseOfVar(v), v.getAUse()))
    or
    comp.getLesserOperand() = overFlowCand() and
    comp.getGreaterOperand().(IntegerLiteral).getIntValue() = 0
  ) and
  // exclude loop conditions as they are unlikely to be overflow tests
  not comp.getEnclosingStmt() instanceof LoopStmt
}

predicate concurrentModificationTest(BinaryExpr test) {
  exists(IfStmt ifstmt, ThrowStmt throw, RefType exc |
    ifstmt.getCondition() = test and
    (ifstmt.getThen() = throw or ifstmt.getThen().(SingletonBlock).getStmt() = throw) and
    throw.getExpr().(ClassInstanceExpr).getConstructedType() = exc and
    exc.hasQualifiedName("java.util", "ConcurrentModificationException")
  )
}

/**
 * Holds if `test` and `guard` are equality tests of the same integral variable v with constants `c1` and `c2`.
 */
pragma[nomagic]
predicate guardedTest(EqualityTest test, Guard guard, boolean isEq, int i1, int i2) {
  exists(SsaVariable v, CompileTimeConstantExpr c1, CompileTimeConstantExpr c2 |
    guard.isEquality(v.getAUse(), c1, isEq) and
    test.hasOperands(v.getAUse(), c2) and
    i1 = c1.getIntValue() and
    i2 = c2.getIntValue() and
    v.getSourceVariable().getType() instanceof IntegralType
  )
}

/**
 * Holds if `guard` implies that `test` always has the value `testIsTrue`.
 */
predicate uselessEqTest(EqualityTest test, boolean testIsTrue, Guard guard) {
  exists(boolean guardIsTrue, boolean guardpolarity, int i |
    guardedTest(test, guard, guardpolarity, i, i) and
    guard.controls(test.getBasicBlock(), guardIsTrue) and
    testIsTrue = guardIsTrue.booleanXor(guardpolarity.booleanXor(test.polarity()))
  )
}

from BinaryExpr test, boolean testIsTrue, string reason, ExprParent reasonElem
where
  (
    if uselessEqTest(test, _, _)
    then
      exists(EqualityTest r |
        uselessEqTest(test, testIsTrue, r) and reason = ", because of $@" and reasonElem = r
      )
    else
      if constCondSimple(test, _)
      then constCondSimple(test, testIsTrue) and reason = "" and reasonElem = test // dummy reason element
      else
        exists(CondReason r |
          constCond(test, testIsTrue, r) and reason = ", because of $@" and reasonElem = r.getCond()
        )
  ) and
  not overFlowTest(test) and
  not concurrentModificationTest(test) and
  not exists(AssertStmt assert | assert.getExpr() = test.getParent*())
select test, "Test is always " + testIsTrue + reason + ".", reasonElem, "this condition"
