/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id rust/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import codeql.rust.dataflow.DataFlow
/*import codeql.rust.security.SqlInjectionQuery
import SqlInjectionFlow::PathGraph

from SqlInjectionFlow::PathNode sourceNode, SqlInjectionFlow::PathNode sinkNode
where SqlInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This query depends on a $@.",
  sourceNode.getNode(), "user-provided value"
*/
select 0
