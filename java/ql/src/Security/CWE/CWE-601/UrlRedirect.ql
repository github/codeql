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

module UrlRedirectConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

module UrlRedirectFlow = TaintTracking::Global<UrlRedirectConfig>;

import UrlRedirectFlow::PathGraph

from UrlRedirectFlow::PathNode source, UrlRedirectFlow::PathNode sink
where UrlRedirectFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection depends on a $@.", source.getNode(),
  "user-provided value"
