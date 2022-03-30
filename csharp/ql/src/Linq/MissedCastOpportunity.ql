/**
 * @name Missed opportunity to use Cast
 * @description The intent of a foreach loop that immediately casts its iteration variable to another type and then
 *              never uses the iteration variable again can often be better expressed using LINQ's 'Cast' method.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/linq/missed-cast
 * @tags maintainability
 *       language-features
 */

import csharp
import Linq.Helpers

from ForeachStmt fes, LocalVariableDeclStmt s
where missedCastOpportunity(fes, s)
select fes,
  "This foreach loop immediately casts its iteration variable to another type $@ - consider casting the sequence explicitly using '.Cast(...)'.",
  s, "here"
