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
import semmle.go.security.OpenUrlRedirect::OpenUrlRedirect
import semmle.go.security.SafeUrlFlow
import DataFlow::PathGraph

from
  Configuration cfg, SafeUrlFlow::Configuration scfg, DataFlow::PathNode source,
  DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  // this excludes flow from safe parts of request URLs, for example the full URL when the
  // doing a redirect from `http://<path>` to `https://<path>`
  not scfg.hasFlow(_, sink.getNode())
select sink.getNode(), source, sink, "Untrusted URL redirection due to $@.", source.getNode(),
  "user-provided value"
