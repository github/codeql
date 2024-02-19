/**
 * @name String concatenation in loop
 * @description Performing string concatenation in a loop that iterates many times may affect
 *              performance.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/string-concatenation-in-loop
 * @tags efficiency
 *       maintainability
 */

import semmle.code.java.Type
import semmle.code.java.Expr
import semmle.code.java.Statement
import semmle.code.java.JDK

/**
 * An assignment of the form
 *
 * ```
 *   v = ... + ... v ...
 * ```
 * or
 *
 * ```
 *   v += ...
 * ```
 * where `v` is a simple variable (and not, for example,
 * an array element).
 */
predicate useAndDef(Assignment a, Variable v) {
  a.getDest() = v.getAnAccess() and
  v.getType() instanceof TypeString and
  (
    a instanceof AssignAddExpr
    or
    exists(VarAccess use | use.getVariable() = v | use.getParent*() = a.getSource()) and
    a.getSource() instanceof AddExpr
  )
}

predicate declaredInLoop(LocalVariableDecl v, LoopStmt loop) {
  exists(LocalVariableDeclExpr e |
    e.getVariable() = v and
    e.getEnclosingStmt().getEnclosingStmt*() = loop.getBody()
  )
  or
  exists(EnhancedForStmt for | for = loop | for.getVariable().getVariable() = v)
}

/**
 * Holds if `e` is executed often in loop `loop`.
 *
 * Checks that `e` is not in a block that breaks out of the loop.
 *
 * A more principled way would be to check for loops in the control flow graph.
 */
predicate executedOften(Assignment e, LoopStmt loop) {
  e.getEnclosingStmt().getEnclosingStmt*() = loop and
  not loop.(ForStmt).getInit(_) = e.getParent*() and
  not exists(BreakStmt b | b.getEnclosingStmt() = e.getEnclosingStmt().getEnclosingStmt())
}

predicate executedOftenCFG(Assignment a) {
  a.getDest().getType() instanceof TypeString and
  exists(ControlFlowNode n | a.getControlFlowNode() = n | n.getASuccessor+() = n)
}

ControlFlowNode test(ControlFlowNode n) {
  exists(Assignment a | a.getControlFlowNode() = n | a.getDest().getType() instanceof TypeString) and
  result = n.getASuccessor+()
}

from Assignment a, Variable v
where
  useAndDef(a, v) and
  (
    exists(LoopStmt loop | executedOften(a, loop) | not declaredInLoop(v, loop))
    or
    executedOftenCFG(a)
  )
select a, "The string " + v.getName() + " is built-up in a loop: use string buffer."
