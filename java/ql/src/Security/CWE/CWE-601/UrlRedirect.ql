/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user-input
 *              may cause redirection to malicious web sites.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 */
import java
import semmle.code.java.dataflow.FlowSources
import UrlRedirect

class UrlRedirectConfig extends TaintTracking::Configuration {
  UrlRedirectConfig() { this = "UrlRedirectConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

from UrlRedirectSink sink, RemoteUserInput source, UrlRedirectConfig conf
where conf.hasFlow(source, sink)
select sink, "Potentially untrusted URL redirection due to $@.",
  source, "user-provided value"
