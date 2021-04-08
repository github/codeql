/**
 * @name XPath query built from user-controlled sources
 * @description Building a XPath query from user-controlled sources is vulnerable to insertion of
 *              malicious Xpath code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import python
import semmle.python.security.Paths
import semmle.python.security.strings.Untrusted
/* Sources */
import semmle.python.web.HttpRequest
/* Sinks */
import experimental.semmle.python.security.injection.Xpath

class XpathInjectionConfiguration extends TaintTracking::Configuration {
  XpathInjectionConfiguration() { this = "Xpath injection configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) {
    sink instanceof XpathInjection::XpathInjectionSink
  }
}

from XpathInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "This Xpath query depends on $@.", src.getSource(),
  "a user-provided value"
