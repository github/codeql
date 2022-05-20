/**
 * @name Integer overflow
 * @description Integer overflow can cause incorrect results or program crashes.
 * @kind problem
 * @problem.severity warning
 * @id go/integer-overflow
 */

import go
import RangeAnalysis

from Expr expr
where exprMayOverflow(expr) or exprMayUnderflow(expr)
select expr, "this expression may cause an integer overflow"
