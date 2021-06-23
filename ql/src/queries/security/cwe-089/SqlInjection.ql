/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id rb/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 *       external/owasp/owasp-a1
 */

import ruby
import codeql_ruby.Concepts
import codeql_ruby.DataFlow
import codeql_ruby.dataflow.BarrierGuards
import codeql_ruby.dataflow.RemoteFlowSources
import codeql_ruby.TaintTracking
import DataFlow::PathGraph

class SQLInjectionConfiguration extends TaintTracking::Configuration {
  SQLInjectionConfiguration() { this = "SQLInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(SqlExecution e) }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare or
    guard instanceof StringConstArrayInclusionCall
  }
}

from SQLInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This SQL query depends on $@.", source.getNode(),
  "a user-provided value"
