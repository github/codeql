/**
 * @name Uncontrolled data used in remote request
 * @description Sending remote requests with user-controlled data allows for request forgery attacks.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id js/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import javascript
import semmle.javascript.security.dataflow.RequestForgery::RequestForgery

from Configuration cfg, DataFlow::Node source, Sink sink, DataFlow::Node request
where cfg.hasFlow(source, sink) and
      request = sink.getARequest()
select request, "The $@ of this request depends on $@.", sink, sink.getKind(), source, "a user-provided value"
