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
import semmle.go.security.RequestForgery::RequestForgery
import semmle.go.security.SafeUrlFlow
import DataFlow::PathGraph

from
  Configuration cfg, SafeUrlFlow::Configuration scfg, DataFlow::PathNode source,
  DataFlow::PathNode sink, DataFlow::Node request
where
  cfg.hasFlowPath(source, sink) and
  request = sink.getNode().(Sink).getARequest() and
  // this excludes flow from safe parts of request URLs, for example the full URL
  not scfg.hasFlow(_, sink.getNode())
select request, source, sink, "The $@ of this request depends on $@.", sink.getNode(),
  sink.getNode().(Sink).getKind(), source, "a user-provided value"
