/**
 * @name Return statement assigns local variable
 * @description An assignment to a local variable in a return statement is useless, since the variable will
 *              immediately go out of scope and its value is lost.
 * @kind problem
 * @problem.severity warning
 * @id js/useless-assignment-in-return
 * @tags maintainability
 *       readability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

from ReturnStmt r, AssignExpr assgn, Variable v
where
  assgn = r.getExpr().stripParens() and
  v = r.getContainer().(Function).getScope().getAVariable() and
  not v.isCaptured() and
  assgn.getLhs() = v.getAnAccess()
select r.(FirstLineOf),
  "The assignment to " + v.getName() +
    " is useless, since it is a local variable and will go out of scope."
