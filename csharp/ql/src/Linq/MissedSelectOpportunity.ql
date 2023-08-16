/**
 * @name Missed opportunity to use Select
 * @description The intent of a foreach loop that immediately maps its iteration variable to another variable and then
 *              never uses the iteration variable again can often be better expressed using LINQ's 'Select' method.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/linq/missed-select
 * @tags maintainability
 *       language-features
 */

import csharp
import Linq.Helpers

predicate oversized(LocalVariableDeclStmt s) {
  exists(Location loc |
    loc = s.getLocation() and
    loc.getEndColumn() - loc.getStartColumn() > 65
  )
}

from ForeachStmtGenericEnumerable fes, LocalVariableDeclStmt s
where
  missedSelectOpportunity(fes, s) and
  not oversized(s)
select fes,
  "This foreach loop immediately $@ - consider mapping the sequence explicitly using '.Select(...)'.",
  s, "maps its iteration variable to another variable"
