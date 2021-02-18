/**
 * @name Information exposure through an exception
 * @description Leaking information about an exception, such as messages and stack traces, to an
 *              external user can expose implementation details that are useful to an attacker for
 *              developing a subsequent exploit.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import python
import semmle.python.security.Paths
import semmle.python.security.Exceptions
import semmle.python.web.HttpResponse

class StackTraceExposureConfiguration extends TaintTracking::Configuration {
  StackTraceExposureConfiguration() { this = "Stack trace exposure configuration" }

  override predicate isSource(TaintTracking::Source source) { source instanceof ErrorInfoSource }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof HttpResponseTaintSink }
}

from StackTraceExposureConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ may be exposed to an external user", src.getSource(),
  "Error information"
