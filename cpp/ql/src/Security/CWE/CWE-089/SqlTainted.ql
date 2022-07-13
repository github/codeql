/**
 * @name Uncontrolled data in SQL query
 * @description Including user-supplied data in a SQL query without
 *              neutralizing special elements can make code vulnerable
 *              to SQL Injection.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
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

class SqlLikeFunction extends FunctionWithWrappers {
  SqlLikeFunction() { sqlArgument(this.getName(), _) }

  override predicate interestingArg(int arg) { sqlArgument(this.getName(), arg) }
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) {
    exists(SqlLikeFunction runSql | runSql.outermostWrapperFunctionCall(tainted, _))
  }

  override predicate isBarrier(Expr e) {
    super.isBarrier(e)
    or
    e.getUnspecifiedType() instanceof IntegralType
    or
    exists(SqlBarrierFunction sql, int arg, FunctionInput input |
      e = sql.getACallToThisFunction().getArgument(arg) and
      input.isParameterDeref(arg) and
      sql.barrierSqlArgument(input, _)
    )
  }
}

from
  SqlLikeFunction runSql, Expr taintedArg, Expr taintSource, PathNode sourceNode, PathNode sinkNode,
  string taintCause, string callChain
where
  runSql.outermostWrapperFunctionCall(taintedArg, callChain) and
  taintedWithPath(taintSource, taintedArg, sourceNode, sinkNode) and
  isUserInput(taintSource, taintCause)
select taintedArg, sourceNode, sinkNode,
  "This argument to a SQL query function is derived from $@ and then passed to " + callChain,
  taintSource, "user input (" + taintCause + ")"
