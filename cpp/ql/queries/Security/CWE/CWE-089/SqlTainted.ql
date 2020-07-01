/**
 * @name Uncontrolled data in SQL query
 * @description Including user-supplied data in a SQL query without
 *              neutralizing special elements can make code vulnerable
 *              to SQL Injection.
 * @kind path-problem
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
import TaintedWithPath

class SQLLikeFunction extends FunctionWithWrappers {
  SQLLikeFunction() { sqlArgument(this.getName(), _) }

  override predicate interestingArg(int arg) { sqlArgument(this.getName(), arg) }
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) {
    exists(SQLLikeFunction runSql | runSql.outermostWrapperFunctionCall(tainted, _))
  }
}

from
  SQLLikeFunction runSql, Expr taintedArg, Expr taintSource, PathNode sourceNode, PathNode sinkNode,
  string taintCause, string callChain
where
  runSql.outermostWrapperFunctionCall(taintedArg, callChain) and
  taintedWithPath(taintSource, taintedArg, sourceNode, sinkNode) and
  isUserInput(taintSource, taintCause)
select taintedArg, sourceNode, sinkNode,
  "This argument to a SQL query function is derived from $@ and then passed to " + callChain,
  taintSource, "user input (" + taintCause + ")"
