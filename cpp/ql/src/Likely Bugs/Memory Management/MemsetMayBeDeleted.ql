/**
 * @name Call to `memset` may be deleted
 * @description Calling `memset` or `ZeroMemory` on a buffer in order to clear its contents may get optimized away
 *              by the compiler if said buffer is not subsequently used.  This is not desirable
 *              behavior if the buffer contains sensitive data that could be exploited by an attacker.
 *              The workaround is to use `memset_s` or `SecureZeroMemory`, use the `-fno-builtin-memset` compiler flag, or
 *              to write one's own buffer-clearing routine.  See also
 *              https://www.cryptologie.net/article/419/zeroing-memory-compiler-optimizations-and-memset_sC
 *              and https://cwe.mitre.org/data/definitions/14.html.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/memset-may-be-deleted
 * @tags security
 *       external/cwe/cwe-14
 */

import semmle.code.cpp.dataflow.TaintTracking

private predicate memsetFunction(string fn) {
	fn = "memset" or
	fn = "bzero" or
	fn = "ZeroMemory" or
	fn = "FillMemory" 
}
	
from FunctionCall memset
where
  memsetFunction(memset.getTarget().getName()) and
  not exists(TaintTracking::Configuration cf, DataFlow::Node source, DataFlow::Node sink |
    cf.hasFlow(source, sink) and
    source.asExpr() = memset.getArgument(1)
  )
select memset,
  "This call to " + memset.getTarget().getName() + " may be deleted by the compiler."
