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

private predicate isSink(DataFlow::Node sink, string extraText) {
  exists(SqlLikeFunction runSql, string callChain |
    runSql.outermostWrapperFunctionCall(asSinkExpr(sink), callChain) and
    extraText = " and then passed to " + callChain
  )
  or
  // sink defined using models-as-data
  sinkNode(sink, "sql-injection") and extraText = ""
}

module SqlTaintedConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { isSink(node, _) }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
    or
    exists(SqlBarrierFunction sql, int arg, FunctionInput input |
      node.asIndirectArgument() = sql.getACallToThisFunction().getArgument(arg) and
      input.isParameterDeref(arg) and
      sql.barrierSqlArgument(input, _)
    )
    or
    // barrier defined using models-as-data
    barrierNode(node, "sql-injection")
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module SqlTainted = TaintTracking::Global<SqlTaintedConfig>;

from
  FlowSource taintSource, SqlTainted::PathNode sourceNode, SqlTainted::PathNode sinkNode,
  string extraText
where
  SqlTainted::flowPath(sourceNode, sinkNode) and
  isSink(sinkNode.getNode(), extraText) and
  taintSource = sourceNode.getNode()
select sinkNode.getNode(), sourceNode, sinkNode,
  "This argument to a SQL query function is derived from $@" + extraText + ".", taintSource,
  "user input (" + taintSource.getSourceType() + ")"
