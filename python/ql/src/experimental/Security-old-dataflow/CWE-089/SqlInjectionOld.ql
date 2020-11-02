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
import semmle.python.security.Paths
/* Sources */
import semmle.python.web.HttpRequest
/* Sinks */
import semmle.python.security.injection.Sql
import semmle.python.web.django.Db
import semmle.python.web.django.Model

class SQLInjectionConfiguration extends TaintTracking::Configuration {
  SQLInjectionConfiguration() { this = "SQL injection configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof SqlInjectionSink }
}

/*
 * Additional configuration to support tracking of DB objects. Connections, cursors, etc.
 * Without this configuration (or the LegacyConfiguration), the pattern of
 * `any(MyTaintKind k).taints(control_flow_node)` used in DbConnectionExecuteArgument would not work.
 */

class DbConfiguration extends TaintTracking::Configuration {
  DbConfiguration() { this = "DB configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof DjangoModelObjects or
    source instanceof DbConnectionSource
  }
}

from SQLInjectionConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "This SQL query depends on $@.", src.getSource(),
  "a user-provided value"
