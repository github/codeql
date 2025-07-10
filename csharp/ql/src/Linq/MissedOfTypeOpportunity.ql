/**
 * @name Missed opportunity to use OfType
 * @description The intent of a foreach loop that immediately uses 'as' to coerce its iteration variable to another type and then
 *              never uses the iteration variable again can often be better expressed using LINQ's 'OfType' method.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/linq/missed-oftype
 * @tags maintainability
 *       language-features
 */

import csharp
import Linq.Helpers

from ForeachStmtEnumerable fes, LocalVariableDeclStmt s
where missedOfTypeOpportunity(fes, s)
select fes,
  "This foreach loop immediately uses 'as' to $@ - consider using '.OfType(...)' instead.", s,
  "coerce its iteration variable to another type"
