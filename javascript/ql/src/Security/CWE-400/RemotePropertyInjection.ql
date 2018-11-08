/**
 * @name Remote property injection
 * @description Allowing writes to arbitrary properties or calls to arbitrary 
 *       methods of an object may lead to denial-of-service attacks. 
 *   
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id js/remote-property-injection
 * @tags security
 *       external/cwe/cwe-250
 *       external/cwe/cwe-400
  */

import javascript
import semmle.javascript.security.dataflow.RemotePropertyInjection::RemotePropertyInjection
import DataFlow::PathGraph

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "A $@ is used as" + sink.(Sink).getMessage(),
       source, "user-provided value"
