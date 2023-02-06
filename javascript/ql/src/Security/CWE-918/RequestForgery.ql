/**
 * @name Server-side request forgery
 * @description Making a network request with user-controlled data in the URL allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id js/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import javascript
import semmle.javascript.security.dataflow.RequestForgeryQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::Node request
where
  cfg.hasFlowPath(source, sink) and
  request = sink.getNode().(Sink).getARequest()
select request, source, sink, "The $@ of this request depends on a $@.", sink.getNode(),
  sink.getNode().(Sink).getKind(), source, "user-provided value"
