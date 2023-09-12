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
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.TaintTracking
import SqlTainted::PathGraph

class SqlLikeFunction extends FunctionWithWrappers {
  SqlLikeFunction() { sqlArgument(this.getName(), _) }

  override predicate interestingArg(int arg) { sqlArgument(this.getName(), arg) }
}

Expr asSinkExpr(DataFlow::Node node) {
  result = node.asIndirectArgument()
  or
  // We want the conversion so we only get one node for the expression
  result = node.asExpr()
}

module SqlTaintedConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(SqlLikeFunction runSql | runSql.outermostWrapperFunctionCall(asSinkExpr(node), _))
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
  }

  predicate isBarrierIn(DataFlow::Node node) {
    exists(SqlBarrierFunction sql, int arg, FunctionInput input |
      node.asIndirectArgument() = sql.getACallToThisFunction().getArgument(arg) and
      input.isParameterDeref(arg) and
      sql.barrierSqlArgument(input, _)
    )
  }
}

module SqlTainted = TaintTracking::Global<SqlTaintedConfig>;

from
  SqlLikeFunction runSql, Expr taintedArg, FlowSource taintSource, SqlTainted::PathNode sourceNode,
  SqlTainted::PathNode sinkNode, string callChain
where
  runSql.outermostWrapperFunctionCall(taintedArg, callChain) and
  SqlTainted::flowPath(sourceNode, sinkNode) and
  taintedArg = asSinkExpr(sinkNode.getNode()) and
  taintSource = sourceNode.getNode()
select taintedArg, sourceNode, sinkNode,
  "This argument to a SQL query function is derived from $@ and then passed to " + callChain + ".",
  taintSource, "user input (" + taintSource.getSourceType() + ")"
