/**
 * @name Server Side Template Injection
 * @description Using user-controlled data to create a template can cause security issues.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/template-injection
 * @tags security
 *       external/cwe/cwe-074
 */

import python
import semmle.python.security.Paths
/* Sources */
import semmle.python.web.HttpRequest
/* Sinks */
import experimental.semmle.python.templates.Ssti
/* Flow */
import semmle.python.security.strings.Untrusted

class TemplateInjectionConfiguration extends TaintTracking::Configuration {
  TemplateInjectionConfiguration() { this = "Template injection configuration" }

  deprecated override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  deprecated override predicate isSink(TaintTracking::Sink sink) { sink instanceof SSTISink }
}

from TemplateInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "This Template depends on $@.", src.getSource(),
  "a user-provided value"
