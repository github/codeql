/**
 * @name Continue statement that does not continue
 * @description A 'continue' statement only re-runs the loop if the loop-condition is true. Therefore
 *              using 'continue' in a loop with a constant false condition is misleading and usually
 *              a bug.
 * @kind problem
 * @id cpp/continue-in-false-loop
 * @problem.severity warning
 * @precision high
 * @tags correctness
 */

import cpp

/**
 * Gets a `do` ... `while` loop with a constant false condition.
 */
DoStmt getAFalseLoop() {
  result.getControllingExpr().getValue() = "0" and
  not result.getControllingExpr().isAffectedByMacro()
}

/**
 * Gets a `do` ... `while` loop surrounding a statement.  This is blocked by a
 * `switch` statement, since a `continue` inside a `switch` inside a loop may be
 * jusitifed (`continue` breaks out of the loop whereas `break` only escapes the
 * `switch`).
 */
DoStmt enclosingLoop(Stmt s) {
  exists(Stmt parent |
    parent = s.getParent() and
    (
      parent instanceof Loop and
      result = parent
      or
      not parent instanceof Loop and
      not parent instanceof SwitchStmt and
      result = enclosingLoop(parent)
    )
  )
}

from DoStmt loop, ContinueStmt continue
where
  loop = getAFalseLoop() and
  loop = enclosingLoop(continue)
select continue, "This 'continue' never re-runs the loop - the $@ is always false.",
  loop.getControllingExpr(), "loop condition"
