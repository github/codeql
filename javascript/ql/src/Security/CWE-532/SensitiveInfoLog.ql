/**
 * @name Insertion of sensitive information into log files
 * @description Writing sensitive information to log files can give valuable
 *              guidance to an attacker or expose sensitive user information.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id js/sensitiveinfo-in-logfile
 * @tags security
 *       external/cwe/cwe-532
 */

import javascript
import semmle.javascript.security.dataflow.SensitiveInfoLogQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Outputting $@ to log.", source.getNode(),
  source.getNode().(Source).describe() // TODO: <- check that this is pretty.
