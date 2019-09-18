/**
 * @name Multiple variable declarations on one line
 * @description There should be no more than one variable declaration per line.
 * @kind problem
 * @id cpp/jpl-c/multiple-var-decls-per-line
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from DeclStmt d
where
  exists(Variable v1, Variable v2 | v1 = d.getADeclaration() and v2 = d.getADeclaration() |
    v1 != v2 and
    v1.getLocation().getStartLine() = v2.getLocation().getStartLine()
  )
select d, "Multiple variable declarations on the same line."
