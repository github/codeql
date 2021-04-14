/**
 * Provides predicates for reasoning about when the value of an expression is
 * guarded by an operation such as `<`, which confines its range.
 */

import cpp
import semmle.code.cpp.controlflow.Dominance
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * Holds if the value of `use` is guarded using `abs`.
 */
predicate guardedAbs(Operation e, Expr use) {
  exists(FunctionCall fc | fc.getTarget().getName() = "abs" |
    fc.getArgument(0).getAChild*() = use and
    guardedLesser(e, fc)
  )
}

/**
 * Gets the position of `stmt` in basic block `block` (this is a thin layer
 * over `BasicBlock.getNode`, intended to improve performance).
 */
pragma[noinline]
private int getStmtIndexInBlock(BasicBlock block, Stmt stmt) { block.getNode(result) = stmt }

pragma[inline]
private predicate stmtDominates(Stmt dominator, Stmt dominated) {
  // In same block
  exists(BasicBlock block, int dominatorIndex, int dominatedIndex |
    dominatorIndex = getStmtIndexInBlock(block, dominator) and
    dominatedIndex = getStmtIndexInBlock(block, dominated) and
    dominatedIndex >= dominatorIndex
  )
  or
  // In (possibly) different blocks
  bbStrictlyDominates(dominator.getBasicBlock(), dominated.getBasicBlock())
}

/**
 * Holds if the value of `use` is guarded to be less than something.
 */
pragma[nomagic]
predicate guardedLesser(Operation e, Expr use) {
  exists(IfStmt c, RelationalOperation guard |
    use = guard.getLesserOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    stmtDominates(c.getThen(), e.getEnclosingStmt())
  )
  or
  exists(Loop c, RelationalOperation guard |
    use = guard.getLesserOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    stmtDominates(c.getStmt(), e.getEnclosingStmt())
  )
  or
  exists(ConditionalExpr c, RelationalOperation guard |
    use = guard.getLesserOperand().getAChild*() and
    guard = c.getCondition().getAChild*() and
    c.getThen().getAChild*() = e
  )
  or
  guardedAbs(e, use)
}

/**
 * Holds if the value of `use` is guarded to be greater than something.
 */
pragma[nomagic]
predicate guardedGreater(Operation e, Expr use) {
  exists(IfStmt c, RelationalOperation guard |
    use = guard.getGreaterOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    stmtDominates(c.getThen(), e.getEnclosingStmt())
  )
  or
  exists(Loop c, RelationalOperation guard |
    use = guard.getGreaterOperand().getAChild*() and
    guard = c.getControllingExpr().getAChild*() and
    stmtDominates(c.getStmt(), e.getEnclosingStmt())
  )
  or
  exists(ConditionalExpr c, RelationalOperation guard |
    use = guard.getGreaterOperand().getAChild*() and
    guard = c.getCondition().getAChild*() and
    c.getThen().getAChild*() = e
  )
  or
  guardedAbs(e, use)
}

/**
 * Gets a use of a given variable `v`.
 */
VariableAccess varUse(LocalScopeVariable v) { result = v.getAnAccess() }

/**
 * Holds if `e` potentially overflows and `use` is an operand of `e` that is not guarded.
 */
predicate missingGuardAgainstOverflow(Operation e, VariableAccess use) {
  (
    convertedExprMightOverflowPositively(e)
    or
    // Ensure that the predicate holds when range analysis cannot determine an upper bound
    upperBound(e.getFullyConverted()) = exprMaxVal(e.getFullyConverted())
  ) and
  use = e.getAnOperand() and
  exists(LocalScopeVariable v | use.getTarget() = v |
    // overflow possible if large
    e instanceof AddExpr and not guardedLesser(e, varUse(v))
    or
    e instanceof AssignAddExpr and not guardedLesser(e, varUse(v))
    or
    e instanceof IncrementOperation and
    not guardedLesser(e, varUse(v)) and
    v.getUnspecifiedType() instanceof IntegralType
    or
    // overflow possible if large or small
    e instanceof MulExpr and
    not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v)))
  )
}

/**
 * Holds if `e` potentially underflows and `use` is an operand of `e` that is not guarded.
 */
predicate missingGuardAgainstUnderflow(Operation e, VariableAccess use) {
  (
    convertedExprMightOverflowNegatively(e)
    or
    // Ensure that the predicate holds when range analysis cannot determine a lower bound
    lowerBound(e.getFullyConverted()) = exprMinVal(e.getFullyConverted())
  ) and
  use = e.getAnOperand() and
  exists(LocalScopeVariable v | use.getTarget() = v |
    // underflow possible if use is left operand and small
    use = e.(SubExpr).getLeftOperand() and not guardedGreater(e, varUse(v))
    or
    use = e.(AssignSubExpr).getLValue() and not guardedGreater(e, varUse(v))
    or
    // underflow possible if small
    e instanceof DecrementOperation and
    not guardedGreater(e, varUse(v)) and
    v.getUnspecifiedType() instanceof IntegralType
    or
    // underflow possible if large or small
    e instanceof MulExpr and
    not (guardedLesser(e, varUse(v)) and guardedGreater(e, varUse(v)))
  )
}
