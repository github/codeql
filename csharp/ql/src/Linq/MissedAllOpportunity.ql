/**
 * @name Missed opportunity to use All
 * @description The intent of a foreach loop that checks whether every element of its target sequence satisfies some predicate can be expressed
 *              more directly using LINQ's 'All' method.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/linq/missed-all
 * @tags maintainability
 *       language-features
 */

import csharp
import Helpers

/*
 * The purpose of this query is to find loops of the following form:
 *
 * bool allEven = true;
 * foreach(int i in lst)
 * {
 *  if(i % 2 != 0)
 *  {
 *    allEven = false;
 *    break;
 *  }
 * }
 *
 * This could be written more cleanly as:
 *
 * bool allEven = lst.All(i => i % 2 == 0);
 */

from ForeachStmt fes
where missedAllOpportunity(fes)
select fes,
  "This foreach loop looks as if it might be testing whether every sequence element satisfies a predicate - consider using '.All(...)'."
