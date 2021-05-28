/**
 * @name Server Side Request Forgery (SSRF)
 * @description Making web requests based on unvalidated user-input
 *              may cause server to communicate with malicious servers.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import java
import semmle.code.java.dataflow.FlowSources
import RequestForgery
import DataFlow::PathGraph

class RequestForgeryConfiguration extends TaintTracking::Configuration {
  RequestForgeryConfiguration() { this = "Server Side Request Forgery" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgerySink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    requestForgeryStep(pred, succ)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestForgeryConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential server side request forgery due to $@.",
  source.getNode(), "a user-provided value"
