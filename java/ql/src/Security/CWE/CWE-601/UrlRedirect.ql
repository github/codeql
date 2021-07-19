/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user-input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id java/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.UrlRedirect
import DataFlow::PathGraph

class UrlRedirectConfig extends TaintTracking::Configuration {
  UrlRedirectConfig() { this = "UrlRedirectConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UrlRedirectConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL redirection due to $@.",
  source.getNode(), "user-provided value"
