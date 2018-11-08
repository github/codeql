/**
 * @name Uncontrolled data used in network request
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id js/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import javascript
import semmle.javascript.security.dataflow.RequestForgery::RequestForgery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink, DataFlow::Node request
where cfg.hasFlow(source, sink) and
      request = sink.getARequest()
select request, "The $@ of this request depends on $@.", sink, sink.(Sink).getKind(), source, "a user-provided value"
