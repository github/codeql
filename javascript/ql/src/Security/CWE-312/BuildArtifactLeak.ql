/**
 * @name Storage of sensitive information in build artifact
 * @description Including sensitive information in a build artifact can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/build-artifact-leak
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import javascript
import semmle.javascript.security.dataflow.BuildArtifactLeakQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Sensitive data returned by $@ is stored in a build artifact here.", source.getNode(),
  source.getNode().(CleartextLogging::Source).describe()
