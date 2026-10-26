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
deprecated import RequestForgery::RequestForgery
deprecated import RequestForgeryFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, RequestForgeryFlow::PathNode source, RequestForgeryFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  RequestForgeryFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "The URL of this request depends on a $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
