/**
 * @name Remote property injection
 * @description Allowing writes to arbitrary properties of an object may lead to
 *              denial-of-service attacks.
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

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "A $@ is used as" + sink.getNode().(Sink).getMessage(),
  source.getNode(), "user-provided value"
