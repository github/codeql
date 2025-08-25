/**
 * @name Exception text reinterpreted as HTML
 * @description Reinterpreting text from an exception as HTML
 *              can lead to a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id js/xss-through-exception
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.ExceptionXssQuery
import DataFlow::DeduplicatePathGraph<ExceptionXssFlow::PathNode, ExceptionXssFlow::PathGraph>

from PathNode source, PathNode sink
where ExceptionXssFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode())
select sink.getNode(), source, sink,
  "$@ is reinterpreted as HTML without escaping meta-characters.", source.getNode(),
  source.getNode().(Source).getDescription()
