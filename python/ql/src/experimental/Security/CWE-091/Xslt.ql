/**
 * @name XSLT query built from user-controlled sources
 * @description Building a XSLT query from user-controlled sources is vulnerable to insertion of
 *              malicious XSLT code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/xslt-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import python
import semmle.python.security.Paths
/* Sources */
import semmle.python.web.HttpRequest
/* Sinks */
import experimental.semmle.python.security.injection.XSLT

class XSLTInjectionConfiguration extends TaintTracking::Configuration {
  XSLTInjectionConfiguration() { this = "XSLT injection configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) {
    sink instanceof XSLTInjection::XSLTInjectionSink
  }
}

from XSLTInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "This XSLT query depends on $@.", src.getSource(),
  "a user-provided value"
