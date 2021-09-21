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
import semmle.code.cpp.commons.Exclusions

from DeclStmt d
where
  exists(Variable v1, Variable v2 | v1 = d.getADeclaration() and v2 = d.getADeclaration() |
    v1 != v2 and
    v1.getLocation().getStartLine() = v2.getLocation().getStartLine()
  ) and
  // Exclude declarations that are from invocations of system-header macros.
  // Example: FD_ZERO from glibc.
  not isFromSystemMacroDefinition(d)
select d, "Multiple variable declarations on the same line."
