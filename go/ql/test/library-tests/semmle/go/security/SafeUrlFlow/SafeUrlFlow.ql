/**
 * @id go/test-safe-url-flow
 * @kind path-problem
 * @problem.severity recommendation
 */

import go
import semmle.go.security.RequestForgeryCustomizations
import semmle.go.security.OpenUrlRedirectCustomizations
import semmle.go.security.SafeUrlFlow
import SafeUrlFlow::Flow::PathGraph

from SafeUrlFlow::Flow::PathNode source, SafeUrlFlow::Flow::PathNode sink
where SafeUrlFlow::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "A safe URL flows here from $@.", source.getNode(), "here"
