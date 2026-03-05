/**
 * @name SQL injection sources
 * @description Find all user input sources (superglobal accesses).
 * @id php/debug/sqli-sources
 * @kind problem
 */

import codeql.php.AST

from SubscriptExpr sub, VariableName v
where
  v = sub.getObject() and
  v.getValue() = ["$_GET", "$_POST", "$_REQUEST", "$_COOKIE"]
select sub, "User input from " + v.getValue()
