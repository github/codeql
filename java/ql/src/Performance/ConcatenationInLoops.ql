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

/**
 * Holds if `e` is executed often in loop `loop`.
 */
predicate executedOften(Assignment a) {
  a.getDest().getType() instanceof TypeString and
  exists(ControlFlowNode n | a.getControlFlowNode() = n | getADeepSuccessor(n) = n)
}

/** Gets a sucessor of `n`, also following function calls. */
ControlFlowNode getADeepSuccessor(ControlFlowNode n) {
  result = n.getASuccessor+()
  or
  exists(Call c, ControlFlowNode callee | c.(Expr).getControlFlowNode() = n.getASuccessor+() |
    callee = c.getCallee().getBody().getControlFlowNode() and
    result = getADeepSuccessor(callee)
  )
}

from Assignment a, Variable v
where
  useAndDef(a, v) and
  executedOften(a)
select a, "The string " + v.getName() + " is built-up in a loop: use string buffer."
