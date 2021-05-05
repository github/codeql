/**
 * @name Uncontrolled data in SQL query to Postgres
 * @description Including user-supplied data in a SQL query to Postgres
 *              without neutralizing special elements can make code
 *              vulnerable to SQL Injection.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cpp/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

predicate pqxxTransationClassNames(string class_name, string namespace) {
  class_name = "dbtransaction" and namespace = "pqxx"
  or
  class_name = "nontransaction" and namespace = "pqxx"
  or
  class_name = "basic_robusttransaction" and namespace = "pqxx"
  or
  class_name = "robusttransaction" and namespace = "pqxx"
  or
  class_name = "subtransaction" and namespace = "pqxx"
  or
  class_name = "transaction" and namespace = "pqxx"
  or
  class_name = "basic_transaction" and namespace = "pqxx"
  or
  class_name = "transaction_base" and namespace = "pqxx"
  or
  class_name = "work" and namespace = "pqxx"
}

predicate pqxxConnectionClassNames(string class_name, string namespace) {
  class_name = "connection_base" and namespace = "pqxx"
  or
  class_name = "basic_connection" and namespace = "pqxx"
  or
  class_name = "connection" and namespace = "pqxx"
}

predicate pqxxTransactionSqlArgument(string function, int arg) {
  function = "exec" and arg = 0
  or
  function = "exec0" and arg = 0
  or
  function = "exec1" and arg = 0
  or
  function = "exec_n" and arg = 1
  or
  function = "exec_params" and arg = 0
  or
  function = "exec_params0" and arg = 0
  or
  function = "exec_params1" and arg = 0
  or
  function = "exec_params_n" and arg = 1
  or
  function = "query_value" and arg = 0
  or
  function = "stream" and arg = 0
}

predicate pqxxConnectionSqlArgument(string function, int arg) { function = "prepare" and arg = 1 }

Expr getPqxxSqlArgument() {
  exists(FunctionCall fc, Expr e, int argIndex, Type t |
    // examples: 'work' for 'work.exec(...)'; '->' for 'tx->exec()'.
    e = fc.getQualifier() and
    // to find ConnectionHandle/TransationHandle and similar classes which override '->' operator behavior
    // and return pointer to a connection/transation object
    e.getType().refersTo(t) and
    // transation exec and connection prepare variations
    (
      pqxxTransationClassNames(t.getName(), _) and
      pqxxTransactionSqlArgument(fc.getTarget().getName(), argIndex)
      or
      pqxxConnectionClassNames(t.getName(), _) and
      pqxxConnectionSqlArgument(fc.getTarget().getName(), argIndex)
    ) and
    result = fc.getArgument(argIndex)
  )
}

predicate pqxxEscapeArgument(string function, int arg) {
  arg = 0 and
  (
    function = "esc"
    or
    function = "esc_raw"
    or
    function = "quote"
    or
    function = "quote_raw"
    or
    function = "quote_name"
    or
    function = "quote_table"
    or
    function = "esc_like"
  )
}

predicate isEscapedPqxxArgument(Expr argExpr) {
  exists(FunctionCall fc, Expr e, int argIndex, Type t |
    // examples: 'work' for 'work.exec(...)'; '->' for 'tx->exec()'.
    e = fc.getQualifier() and
    // to find ConnectionHandle/TransationHandle and similar classes which override '->' operator behavior
    // and return pointer to a connection/transation object
    e.getType().refersTo(t) and
    // transation and connection escape functions
    (pqxxTransationClassNames(t.getName(), _) or pqxxConnectionClassNames(t.getName(), _)) and
    pqxxEscapeArgument(fc.getTarget().getName(), argIndex) and
    // eval is escaped
    argExpr = fc.getArgument(argIndex)
  )
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SqlPqxxTainted" }

  override predicate isSource(DataFlow::Node source) { isUserInput(source.asExpr(), _) }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() = getPqxxSqlArgument() }

  override predicate isSanitizer(DataFlow::Node node) { isEscapedPqxxArgument(node.asExpr()) }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Configuration config, string taintCause
where
  config.hasFlowPath(source, sink) and
  isUserInput(source.getNode().asExpr(), taintCause)
select sink, source, sink, "This argument to a SQL query function is derived from $@", source,
  "user input (" + taintCause + ")"
