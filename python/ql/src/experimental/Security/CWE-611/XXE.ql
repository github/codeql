/**
 * @name XML External Entity abuse
 * @description User input should not be parsed by XML parsers without security options enabled.
 * @kind path-problem
 * @problem.severity error
 * @id py/xxe
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

// determine precision above
import python
import experimental.semmle.python.security.XXE
import DataFlow::PathGraph

from XXEFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ XML input is constructed from a $@ and isn't secured against XML External Entities abuse",
  sink.getNode(), "This", source.getNode(), "user-provided value"
