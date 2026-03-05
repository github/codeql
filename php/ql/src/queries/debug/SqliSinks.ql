/**
 * @name SQL injection sinks
 * @description Find all SQL query execution calls.
 * @id php/debug/sqli-sinks
 * @kind problem
 */

import codeql.php.AST

from FunctionCallExpr call
where
  call.getFunctionName() = ["mysql_query", "mysqli_query", "pg_query", "sqlite_query", "sqlite_exec"]
select call, "SQL execution via " + call.getFunctionName()
