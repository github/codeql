/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable
 *              to insertion of malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision medium
 * @id php/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import codeql.php.AST
import codeql.php.DataFlow
import codeql.php.TaintTracking

/**
 * A source of user input from PHP superglobals (`$_GET`, `$_POST`, `$_REQUEST`, `$_COOKIE`).
 */
class UserInputSource extends DataFlow::ExprNode {
  UserInputSource() {
    exists(VariableName v | v = this.asExpr() |
      v.getValue() = "$_GET" or
      v.getValue() = "$_POST" or
      v.getValue() = "$_REQUEST" or
      v.getValue() = "$_COOKIE"
    )
    or
    exists(SubscriptExpr sub, VariableName v |
      sub = this.asExpr() and
      v = sub.getObject() and
      (
        v.getValue() = "$_GET" or
        v.getValue() = "$_POST" or
        v.getValue() = "$_REQUEST" or
        v.getValue() = "$_COOKIE"
      )
    )
  }
}

/**
 * A call to a SQL execution function.
 */
class SqlSink extends DataFlow::ExprNode {
  SqlSink() {
    exists(FunctionCallExpr call |
      call.getFunctionName() =
        [
          "mysql_query", "mysqli_query", "pg_query", "sqlite_query", "sqlite_exec",
          "mssql_query"
        ] and
      this.asExpr() = call.getArgument(_)
    )
    or
    exists(MethodCallExpr call |
      call.getMethodNameString() = ["query", "exec", "prepare", "execute"] and
      this.asExpr() = call.getArgument(0)
    )
  }
}

module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInputSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof SqlSink }
}

module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

import SqlInjectionFlow::PathGraph

from SqlInjectionFlow::PathNode source, SqlInjectionFlow::PathNode sink
where SqlInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This SQL query depends on a $@.", source.getNode(),
  "user-provided value"
