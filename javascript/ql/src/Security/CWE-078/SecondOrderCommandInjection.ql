/**
 * @name Second order command injection
 * @description Some shell programs allow arbitrary command execution via their command line arguments.
 *              This is a second order command injection vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id js/second-order-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.SecondOrderCommandInjectionQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Command line argument that allows for arbitrary command execution depends on $@.",
  source.getNode(), source.getNode().(Source).describe()
