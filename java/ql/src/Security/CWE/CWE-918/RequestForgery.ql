/**
 * @name Server-side request forgery
 * @description Making web requests based on unvalidated user-input
 *              may cause the server to communicate with malicious servers.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id java/ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import java
import semmle.code.java.security.RequestForgeryConfig
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestForgeryConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential server-side request forgery due to $@.",
  source.getNode(), "a user-provided value"
