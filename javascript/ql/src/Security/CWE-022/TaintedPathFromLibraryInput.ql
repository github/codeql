/**
 * @name Library input used in path expression
 * @description Accessing paths dependent on library input can make library
 *      users vulnerable to path injection attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.0
 * @precision high
 * @id js/path-injection-from-library-input
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import javascript
import semmle.javascript.security.dataflow.TaintedPathFromLibraryInputQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on $@.", source.getNode(), "library input"
