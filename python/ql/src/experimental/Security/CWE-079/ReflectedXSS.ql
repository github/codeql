/**
 * @name Reflected server-side cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 2.9
 * @sub-severity high
 * @id py/reflective-xss-email
 * @tags security
 *       experimental
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

// determine precision above
import python
import experimental.semmle.python.security.dataflow.ReflectedXSS
import DataFlow::PathGraph

from ReflectedXssConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "a user-provided value"
