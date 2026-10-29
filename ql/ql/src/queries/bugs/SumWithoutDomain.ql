/**
 * @name Sum is missing a domain
 * @description An aggregate like 'sum' should work over a domain, otherwise duplicate values will not be counted.
 * @kind problem
 * @problem.severity error
 * @id ql/sum-missing-domain
 * @tags correctness
 * @precision medium
 */

import ql

from ExprAggregate agg
where agg.getKind() = ["sum", "strictsum", "avg"]
select agg,
  "This " + agg.getKind() + " does not have a domain argument, so may produce surprising results."
