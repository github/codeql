/**
 * @name Server-side request forgery
 * @description Making a network request with user-controlled data in the URL allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/request-forgery
 * @tags security
 *       experimental
 *       external/cwe/cwe-918
 */

import csharp
import RequestForgery::RequestForgery
import RequestForgeryFlow::PathGraph

from RequestForgeryFlow::PathNode source, RequestForgeryFlow::PathNode sink
where RequestForgeryFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "The URL of this request depends on a $@.", source.getNode(),
  "user-provided value"
