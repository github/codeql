/**
 * @name Number of statements
 * @description Counts the number of statements nesting in each callable element (callables are methods, constructors, operators, accessors, ...).
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/statements-per-function
 */

import csharp

from Callable c, int n
where
  c.isSourceDeclaration() and
  n =
    count(Stmt s |
      s.getEnclosingCallable() = c and
      s != c.getAChild() // we do not count the top-level block
    )
select c, n order by n desc
