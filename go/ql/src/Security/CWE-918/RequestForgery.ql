/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id go/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import go
import semmle.go.security.RequestForgery
import semmle.go.security.SafeUrlFlow
import RequestForgery::Flow::PathGraph

from
  RequestForgery::Flow::PathNode source, RequestForgery::Flow::PathNode sink, DataFlow::Node request
where
  RequestForgery::Flow::flowPath(source, sink) and
  request = sink.getNode().(RequestForgery::Sink).getARequest() and
  // this excludes flow from safe parts of request URLs, for example the full URL
  not SafeUrlFlow::Flow::flow(_, sink.getNode())
select request, source, sink, "The $@ of this request depends on a $@.", sink.getNode(),
  sink.getNode().(RequestForgery::Sink).getKind(), source, "user-provided value"
