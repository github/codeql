/**
 * @name DuplicateStatements
 * @description Insert description here...
 * @kind problem
 * @problem.severity warning
 */

import python
import external.CodeDuplication

predicate mostlyDuplicateFunction(Function f) {
  exists(int covered, int total, Function other, int percent |
    duplicateStatements(f, other, covered, total) and
    covered != total and
    total > 5 and
    covered * 100 / total = percent and
    percent > 80 and
    not exists(Scope s | s = f.getScope*() | duplicateScopes(s, _, _, _))
  )
}

from Stmt s
where
  mostlyDuplicateFunction(s.getScope()) and
  not duplicateStatement(s.getScope(), _, s, _)
select s.toString(), s.getLocation().toString()
