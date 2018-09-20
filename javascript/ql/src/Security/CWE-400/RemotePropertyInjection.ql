/**
 * @name Remote property injection
 * @description Allowing writes to arbitrary properties or calls to arbitrary 
 *       methods of an object may lead to denial-of-service attacks. 
 *   
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id js/remote-property-injection
 * @tags security
 *       external/cwe/cwe-250
 *       external/cwe/cwe-400
  */

import javascript
import semmle.javascript.security.dataflow.RemotePropertyInjection::RemotePropertyInjection

from Configuration c, DataFlow::Node source, Sink sink
where c.hasFlow(source, sink)  
select sink, "A $@ is used as" + sink.getMessage(),
       source, "user-provided value"
       
