/**
 * @name Open URL redirect
 * @description Open URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @id go/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import go
import semmle.go.security.OpenUrlRedirect
import semmle.go.security.SafeUrlFlow
import OpenUrlRedirect::Flow::PathGraph

from OpenUrlRedirect::Flow::PathNode source, OpenUrlRedirect::Flow::PathNode sink
where
  OpenUrlRedirect::Flow::flowPath(source, sink) and
  // this excludes flow from safe parts of request URLs, for example the full URL when the
  // doing a redirect from `http://<path>` to `https://<path>`
  not SafeUrlFlow::Flow::flow(_, sink.getNode())
select sink.getNode(), source, sink, "This path to an untrusted URL redirection depends on a $@.",
  source.getNode(), "user-provided value"
