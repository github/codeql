/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/web/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 */

import csharp
import semmle.code.csharp.security.dataflow.UrlRedirect::UrlRedirect
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection due to $@.", source.getNode(),
  "user-provided value"
