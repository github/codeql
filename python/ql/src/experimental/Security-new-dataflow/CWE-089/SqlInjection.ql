/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/owasp/owasp-a1
 */

import python
import experimental.dataflow.DataFlow
import experimental.dataflow.TaintTracking
import experimental.semmle.python.Concepts
import experimental.dataflow.RemoteFlowSources
import DataFlow::PathGraph

class SQLInjectionConfiguration extends TaintTracking::Configuration {
  SQLInjectionConfiguration() { this = "SQLInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(SqlExecution e).getSql() }
}

from SQLInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This SQL query depends on $@.", source.getNode(),
  "a user-provided value"
