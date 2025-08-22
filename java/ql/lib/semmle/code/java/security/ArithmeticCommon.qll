/** Provides guards and predicates to reason about arithmetic. */
overlay[local?]
module;

import semmle.code.java.arithmetic.Overflow
import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.RangeAnalysis
private import semmle.code.java.dataflow.RangeUtils
private import semmle.code.java.dataflow.SignAnalysis

/**
 * Holds if the type of `exp` is narrower than or equal to `numType`,
 * or there is an enclosing cast to a type at least as narrow as 'numType'.
 */
predicate narrowerThanOrEqualTo(ArithExpr exp, NumType numType) {
  exp.getType().(NumType).widerThan(numType)
  implies
  exists(CastingExpr cast | cast.getAChildExpr() = exp | numType.widerThanOrEqualTo(cast.getType()))
}

private Guard sizeGuard(Expr e, boolean branch, boolean upper) {
  exists(ComparisonExpr comp | comp = result |
    comp.getLesserOperand() = e and
    (
      branch = true and upper = true
      or
      branch = false and upper = false
    )
    or
    comp.getGreaterOperand() = e and
    (
      branch = true and upper = false
      or
      branch = false and upper = true
    )
    or
    exists(MethodCall ma |
      ma.getMethod() instanceof MethodAbs and
      ma.getArgument(0) = e and
      (
        comp.getLesserOperand() = ma and branch = true
        or
        comp.getGreaterOperand() = ma and branch = false
      ) and
      (upper = false or upper = true)
    )
    or
    // overflow test
    exists(AddExpr add, VarRead use, Expr pos |
      use = e and
      add.hasOperands(use, pos) and
      positive(use) and
      positive(pos) and
      upper = true
    |
      comp.getLesserOperand() = add and
      comp.getGreaterOperand().(IntegerLiteral).getIntValue() = 0 and
      branch = false
      or
      comp.getGreaterOperand() = add and
      comp.getLesserOperand().(IntegerLiteral).getIntValue() = 0 and
      branch = true
    )
  )
  or
  result.isEquality(e, _, branch) and
  (upper = true or upper = false)
}

private predicate sizeGuardLessThan(Guard g, Expr e, boolean branch) {
  g = sizeGuard(e, branch, true)
}

private predicate sizeGuardGreaterThan(Guard g, Expr e, boolean branch) {
  g = sizeGuard(e, branch, false)
}

/**
 * Holds if `n` is bounded in a way that is likely to prevent overflow.
 */
predicate guardedLessThanSomething(DataFlow::Node n) {
  DataFlow::BarrierGuard<sizeGuardLessThan/3>::getABarrierNode() = n
  or
  negative(n.asExpr())
  or
  n.asExpr().(MethodCall).getMethod() instanceof MethodMathMin
}

/**
 * Holds if `e` is bounded in a way that is likely to prevent underflow.
 */
predicate guardedGreaterThanSomething(DataFlow::Node n) {
  DataFlow::BarrierGuard<sizeGuardGreaterThan/3>::getABarrierNode() = n
  or
  positive(n.asExpr())
  or
  n.asExpr().(MethodCall).getMethod() instanceof MethodMathMax
}

/** Holds if `e` occurs in a context where it will be upcast to a wider type. */
predicate upcastToWiderType(Expr e) {
  exists(NumType t1, NumType t2 |
    t1 = e.getType() and
    (
      t2.widerThan(t1)
      or
      t1 instanceof CharacterType and t2.getWidthRank() >= 3
    )
  |
    exists(Variable v | v.getAnAssignedValue() = e and t2 = v.getType())
    or
    exists(CastingExpr c | c.getExpr() = e and t2 = c.getType())
    or
    exists(ReturnStmt ret | ret.getResult() = e and t2 = ret.getEnclosingCallable().getReturnType())
    or
    exists(Parameter p | p.getAnArgument() = e and t2 = p.getType())
    or
    exists(ConditionalExpr cond | cond.getABranchExpr() = e | t2 = cond.getType())
  )
}

/** Holds if the result of `exp` has certain bits filtered by a bitwise and. */
private predicate inBitwiseAnd(Expr exp) {
  exists(AndBitwiseExpr a | a.getAnOperand() = exp) or
  inBitwiseAnd(exp.(LeftShiftExpr).getAnOperand()) or
  inBitwiseAnd(exp.(RightShiftExpr).getAnOperand()) or
  inBitwiseAnd(exp.(UnsignedRightShiftExpr).getAnOperand())
}

/** Holds if overflow/underflow is irrelevant for this expression. */
predicate overflowIrrelevant(Expr exp) {
  inBitwiseAnd(exp) or
  exp.getEnclosingCallable() instanceof HashCodeMethod
}

/**
 * Holds if `n` is unlikely to be part in a path from some source containing
 * numeric data to some arithmetic expression that may overflow/underflow.
 */
private predicate unlikelyNode(DataFlow::Node n) {
  n.getTypeBound() instanceof TypeObject and
  not exists(CastingExpr cast |
    DataFlow::localFlow(n, DataFlow::exprNode(cast.getExpr())) and
    cast.getType() instanceof NumericOrCharType
  )
}

/** Holds if `n` is likely guarded against overflow. */
predicate overflowBarrier(DataFlow::Node n) {
  n.getType() instanceof BooleanType or
  guardedLessThanSomething(n) or
  unlikelyNode(n) or
  upcastToWiderType(n.asExpr()) or
  overflowIrrelevant(n.asExpr())
}

/** Holds if `n` is likely guarded against underflow. */
predicate underflowBarrier(DataFlow::Node n) {
  n.getType() instanceof BooleanType or
  guardedGreaterThanSomething(n) or
  unlikelyNode(n) or
  upcastToWiderType(n.asExpr()) or
  overflowIrrelevant(n.asExpr())
}

/**
 * Holds if `use` is an operand of `exp` that acts as a sink for
 * overflow-related dataflow.
 */
predicate overflowSink(ArithExpr exp, VarAccess use) {
  exp.getAnOperand() = use and
  (
    // overflow unlikely for subtraction and division
    exp instanceof AddExpr or
    exp instanceof PreIncExpr or
    exp instanceof PostIncExpr or
    exp instanceof MulExpr
  ) and
  // Exclude widening conversions of tainted values due to binary numeric promotion (JLS 5.6.2)
  // unless there is an enclosing cast down to a narrower type.
  narrowerThanOrEqualTo(exp, use.getType()) and
  not overflowIrrelevant(exp)
}

/**
 * Holds if `use` is an operand of `exp` that acts as a sink for
 * underflow-related dataflow.
 */
predicate underflowSink(ArithExpr exp, VarAccess use) {
  exp.getAnOperand() = use and
  (
    // underflow unlikely for addition and division
    exp.(SubExpr).getLeftOperand() = use or
    exp instanceof PreDecExpr or
    exp instanceof PostDecExpr or
    exp instanceof MulExpr
  ) and
  // Exclude widening conversions of tainted values due to binary numeric promotion (JLS 5.6.2)
  // unless there is an enclosing cast down to a narrower type.
  narrowerThanOrEqualTo(exp, use.getType()) and
  not overflowIrrelevant(exp)
}
