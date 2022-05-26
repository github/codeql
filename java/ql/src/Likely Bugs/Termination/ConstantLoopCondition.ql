/**
 * @name Constant loop condition
 * @description A loop condition that remains constant throughout the iteration
 *              indicates faulty logic and is likely to cause infinite
 *              looping.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/constant-loop-condition
 * @tags correctness
 *       external/cwe/cwe-835
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.SSA

predicate loopWhileTrue(LoopStmt loop) {
  loop instanceof ForStmt and not exists(loop.getCondition())
  or
  loop.getCondition().(BooleanLiteral).getBooleanValue() = true
}

/**
 * Holds if `exit` is a `return` or `break` statement that can exit the loop.
 *
 * Note that `throw` statements are not considered loop exits here, since a
 * loop that appears to have a non-exceptional loop exit that cannot be reached
 * is worth flagging even if it has a reachable exceptional loop exit.
 */
predicate loopExit(LoopStmt loop, Stmt exit) {
  exit.getEnclosingStmt*() = loop.getBody() and
  (
    exit instanceof ReturnStmt or
    exit.(BreakStmt).getTarget() = loop.getEnclosingStmt*()
  )
}

/**
 * Holds if `cond` is a condition in the loop that guards all `return` and
 * `break` statements that can exit the loop.
 */
predicate loopExitGuard(LoopStmt loop, Expr cond) {
  exists(ConditionBlock cb, boolean branch |
    cond = cb.getCondition() and
    cond.getEnclosingStmt().getEnclosingStmt*() = loop.getBody() and
    forex(Stmt exit | loopExit(loop, exit) | cb.controls(exit.getBasicBlock(), branch))
  )
}

/**
 * Holds if `loop.getCondition() = cond` and the loop can possibly execute more
 * than once. That is, loops that are always terminated with a `return` or
 * `break` are excluded as they are simply disguised `if`-statements.
 */
predicate mainLoopCondition(LoopStmt loop, Expr cond) {
  loop.getCondition() = cond and
  exists(Expr loopReentry, ControlFlowNode last |
    if exists(loop.(ForStmt).getAnUpdate())
    then loopReentry = loop.(ForStmt).getUpdate(0)
    else loopReentry = cond
  |
    last.getEnclosingStmt().getEnclosingStmt*() = loop.getBody() and
    last.getASuccessor().(Expr).getParent*() = loopReentry
  )
}

from LoopStmt loop, Expr cond
where
  (
    mainLoopCondition(loop, cond)
    or
    loopWhileTrue(loop) and loopExitGuard(loop, cond)
  ) and
  // None of the ssa variables in `cond` are updated inside the loop.
  forex(SsaVariable ssa, RValue use | ssa.getAUse() = use and use.getParent*() = cond |
    not ssa.getCfgNode().getEnclosingStmt().getEnclosingStmt*() = loop or
    ssa.getCfgNode().(Expr).getParent*() = loop.(ForStmt).getAnInit()
  ) and
  // And `cond` does not use method calls, field reads, or array reads.
  not exists(MethodAccess ma | ma.getParent*() = cond) and
  not exists(FieldRead fa |
    // Ignore if field is final
    not fa.getField().isFinal() and
    fa.getParent*() = cond
  ) and
  not exists(ArrayAccess aa | aa.getParent*() = cond)
select cond, "$@ might not terminate, as this loop condition is constant within the loop.", loop,
  "Loop"
