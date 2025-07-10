/**
 * @name Missed opportunity to use Where
 * @description The intent of a foreach loop that implicitly filters its target sequence can often be better expressed using LINQ's 'Where' method.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/linq/missed-where
 * @tags maintainability
 *       language-features
 */

import csharp
import Linq.Helpers

from ForeachStmtGenericEnumerable fes, IfStmt is
where
  missedWhereOpportunity(fes, is) and
  not missedAllOpportunity(fes)
select fes,
  "This foreach loop $@ - consider filtering the sequence explicitly using '.Where(...)'.",
  is.getCondition(), "implicitly filters its target sequence"
