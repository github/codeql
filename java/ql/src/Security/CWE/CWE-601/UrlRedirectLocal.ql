/**
 * @name URL redirection from local source
 * @description URL redirection based on unvalidated user-input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 6.1
 * @precision medium
 * @id java/unvalidated-url-redirection-local
 * @tags security
 *       external/cwe/cwe-601
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.UrlRedirect
import DataFlow::PathGraph

class UrlRedirectLocalConfig extends TaintTracking::Configuration {
  UrlRedirectLocalConfig() { this = "UrlRedirectLocalConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UrlRedirectLocalConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially untrusted URL redirection due to $@.",
  source.getNode(), "user-provided value"
