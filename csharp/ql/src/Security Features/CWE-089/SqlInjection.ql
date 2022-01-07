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
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.security.dataflow.flowsources.Local

string getSourceType(DataFlow::Node node) {
  result = node.(RemoteFlowSource).getSourceType()
  or
  result = node.(LocalFlowSource).getSourceType()
}

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Query might include code from $@.", source,
  ("this " + getSourceType(source.getNode()))
