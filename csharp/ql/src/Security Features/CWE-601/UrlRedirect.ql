/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id cs/web/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 */

import csharp
import semmle.code.csharp.security.dataflow.UrlRedirectQuery
import UrlRedirect::PathGraph

from UrlRedirect::PathNode source, UrlRedirect::PathNode sink
where UrlRedirect::flowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection due to $@.", source.getNode(),
  "user-provided value"
