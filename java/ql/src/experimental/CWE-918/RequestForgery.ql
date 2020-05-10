/**
 * @name Server Sider Request Forgery (SSRF) from remote source
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
import RequestForgery::RequestForgery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestForgeryRemoteConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential server side request forgery due to $@.",
  source.getNode(), "a user-provided value"
