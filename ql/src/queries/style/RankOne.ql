/**
 * @name Selecting minimum element using `rank[1]`
 * @description Selecting the minimum element using `rank[1](..)` performs worse than doing the same thing with `min(..)`.
 * @kind problem
 * @problem.severity warning
 * @id ql/rank-one
 * @tags performance,
 *       maintainability
 * @precision very-high
 */

import ql

from Rank r
where r.getRankExpr().(Integer).getValue() = 1
select r, "Using rank[1](..) is an anti-pattern, use min(..) instead."
