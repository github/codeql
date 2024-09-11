/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id cs/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import csharp
import semmle.code.csharp.security.dataflow.SqlInjectionQuery
import SqlInjection::PathGraph
import semmle.code.csharp.security.dataflow.flowsources.FlowSources

string getSourceType(DataFlow::Node node) { result = node.(SourceNode).getSourceType() }

from SqlInjection::PathNode source, SqlInjection::PathNode sink
where SqlInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on $@.", source,
  ("this " + getSourceType(source.getNode()))
