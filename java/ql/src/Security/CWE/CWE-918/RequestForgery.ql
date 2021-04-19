/**
 * @name Server-side request forgery
 * @description Making web requests based on unvalidated user-input
 *              may cause the server to communicate with malicious servers.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.RequestForgery
import DataFlow::PathGraph

class RequestForgeryConfiguration extends TaintTracking::Configuration {
  RequestForgeryConfiguration() { this = "Server-Side Request Forgery" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    // Exclude results of remote HTTP requests: fetching something else based on that result
    // is no worse than following a redirect returned by the remote server, and typically
    // we're requesting a resource via https which we trust to only send us to safe URLs.
    not source.asExpr().(MethodAccess).getCallee() instanceof URLConnectionGetInputStreamMethod
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgerySink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(RequestForgeryAdditionalTaintStep r).propagatesTaint(pred, succ)
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof RequestForgerySanitizer }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestForgeryConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential server-side request forgery due to $@.",
  source.getNode(), "a user-provided value"
