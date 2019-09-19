/**
 * @name Call to `memset` may be deleted
 * @description Calling `memset` or `ZeroMemory` on a buffer in order to clear its contents may get optimized away
 *              by the compiler if said buffer is not subsequently used.  This is not desirable
 *              behavior if the buffer contains sensitive data that could be exploited by an attacker.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/memset-may-be-deleted
 * @tags security
 *       external/cwe/cwe-14
 */

import semmle.code.cpp.dataflow.TaintTracking

private predicate memsetName(string fn) {
	fn = "memset" or
	fn = "bzero" or
	fn = "ZeroMemory" or
	fn = "FillMemory" 
}
	
from FunctionCall fc, Expr arg, Expr succ
where
  memsetName(fc.getTarget().getName())
  and arg = fc.getArgument(0)
  and DataFlow::localFlow(DataFlow::exprNode(arg), DataFlow::exprNode(succ))
select "Found an edge.", fc, arg, succ
