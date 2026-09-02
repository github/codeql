/**
 * @name Missed opportunity to use FirstOrDefault
 * @description The intent of a foreach loop that returns the first sequence element satisfying a predicate, or a default value otherwise,
 *              can often be better expressed using LINQ's 'FirstOrDefault' method.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/linq/missed-firstordefault
 * @tags quality
 *       maintainability
 *       readability
 *       language-features
 */

import csharp
import Linq.Helpers

from ForeachStmtGenericEnumerable fes, IfStmt is
where missedFirstOrDefaultOpportunity(fes, is)
select fes,
  "This foreach loop returns the first sequence element satisfying a $@ - consider finding the element explicitly using '.FirstOrDefault(...)'.",
  is.getCondition(), "predicate"
