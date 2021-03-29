/**
 * @name Code injection
 * @description OLD QUERY: Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @id py/old/code-injection
 */

import python
import semmle.python.security.Paths
/* Sources */
import semmle.python.web.HttpRequest
/* Sinks */
import semmle.python.security.injection.Exec

class CodeInjectionConfiguration extends TaintTracking::Configuration {
  CodeInjectionConfiguration() { this = "Code injection configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof StringEvaluationNode }
}

from CodeInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "$@ flows to here and is interpreted as code.", src.getSource(),
  "A user-provided value"
