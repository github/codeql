/**
 * @name Uncontrolled data in SQL query
 * @description Including user-supplied data in a SQL query without
 *              neutralizing special elements can make code vulnerable
 *              to SQL Injection.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.TaintTracking

class SQLLikeFunction extends FunctionWithWrappers {
  SQLLikeFunction() { sqlArgument(this.getName(), _) }

  override predicate interestingArg(int arg) { sqlArgument(this.getName(), arg) }
}

from SQLLikeFunction runSql, Expr taintedArg, Expr taintSource, string taintCause, string callChain
where
  runSql.outermostWrapperFunctionCall(taintedArg, callChain) and
  tainted(taintSource, taintedArg) and
  isUserInput(taintSource, taintCause)
select taintedArg,
  "This argument to a SQL query function is derived from $@ and then passed to " + callChain,
  taintSource, "user input (" + taintCause + ")"
