/**
 * @name AV Rule 39
 * @description Header files (*.h) will not contain non-const variable definitions or function definitions.
 * @kind problem
 * @id cpp/jsf/av-rule-39
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

predicate forbidden(Declaration d) {
  d instanceof Variable and not d.(Variable).isConst()
  or
  d instanceof Function and not d.hasSpecifier("inline")
}

from Declaration d
where
  d.getDefinitionLocation().getFile() instanceof HeaderFile and
  forbidden(d)
select d.getDefinitionLocation(),
  "AV Rule 38: header files will not contain non-const variable definitions or function definitions."
