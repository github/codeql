/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/sql-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-089
 */

import powershell
import semmle.code.powershell.security.SqlInjectionQuery
import SqlInjectionFlow::PathGraph

from SqlInjectionFlow::PathNode source, SqlInjectionFlow::PathNode sink, Source sourceNode
where
  SqlInjectionFlow::flowPath(source, sink) and
  sourceNode = source.getNode()
select sink.getNode(), source, sink, "This SQL query depends on a $@.", sourceNode,
  sourceNode.getSourceType()
