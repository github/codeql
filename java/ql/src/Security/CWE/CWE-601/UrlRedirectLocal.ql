/**
 * @name URL redirection from local source
 * @description URL redirection based on unvalidated user-input
 *              may cause redirection to malicious web sites.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/unvalidated-url-redirection-local
 * @tags security
 *       external/cwe/cwe-601
 */
import java
import semmle.code.java.dataflow.FlowSources
import UrlRedirect

class UrlRedirectLocalConfig extends TaintTracking::Configuration {
  UrlRedirectLocalConfig() { this = "UrlRedirectLocalConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

from UrlRedirectSink sink, LocalUserInput source, UrlRedirectLocalConfig conf
where conf.hasFlow(source, sink)
select sink, "Potentially untrusted URL redirection due to $@.",
  source, "user-provided value"
