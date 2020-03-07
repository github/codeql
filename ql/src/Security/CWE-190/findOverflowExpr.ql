/**
 * @name Find integer overflow 
 * @kind problem
 * @description This query is used to find the integer overflow problem that may occur when processing arithmetic operations in the program. Integer overflow often causes the results of the program to be incorrect, or the program crashes and exits.
 */

import go
import RangeAnalysis


from Expr expr
where exprMayOverflow(expr) or exprMayUnderflow(expr)
select expr
