/**
 * @name Server-side URL redirect
 * @description Server-side URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity warning
 * @id js/server-side-unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import javascript
import semmle.javascript.security.dataflow.ServerSideUrlRedirect::ServerSideUrlRedirect
import DataFlow::PathGraph

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "Untrusted URL redirection due to $@.", source, "user-provided value"
