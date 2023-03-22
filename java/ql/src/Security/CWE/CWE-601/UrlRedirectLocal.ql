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

module UrlRedirectLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof UrlRedirectSink }
}

module UrlRedirectLocalFlow = TaintTracking::Make<UrlRedirectLocalConfig>;

import UrlRedirectLocalFlow::PathGraph

from UrlRedirectLocalFlow::PathNode source, UrlRedirectLocalFlow::PathNode sink
where UrlRedirectLocalFlow::hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection depends on a $@.", source.getNode(),
  "user-provided value"
