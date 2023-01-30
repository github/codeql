/**
 * @name Attribute pollution
 * @description Modifying an object obtained via a user-controlled property name may
 *              lead to accidental mutation of the object's attributes,
 *              and possibly escalate to remote code execution or cross-site scripting.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id py/attribute-pollution
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-079
 *       external/cwe/cwe-094
 *       external/cwe/cwe-400
 *       external/cwe/cwe-471
 *       external/cwe/cwe-915
 */

import python
import semmle.python.security.dataflow.AttributePollutionQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink,
  "This assignment may alter $@ if a malicious string is injected from $@.",
  sink.getNode().(Sink).getPollutedObject(), "this object", source.getNode(),
  "a user-provided value"
