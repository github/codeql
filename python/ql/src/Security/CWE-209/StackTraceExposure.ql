/**
 * @name Information exposure through an exception
 * @description Leaking information about an exception, such as messages and stack traces, to an
 *              external user can expose implementation details that are useful to an attacker for
 *              developing a subsequent exploit. 
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import python

import semmle.python.security.Exceptions
import semmle.python.web.HttpResponse

from TaintSource src, TaintSink sink
where src.flowsToSink(sink)
select sink, "$@ may be exposed to an external user", src, "Error information"
