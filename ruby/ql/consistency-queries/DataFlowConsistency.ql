import codeql.ruby.AST
import codeql.ruby.CFG
import codeql.ruby.DataFlow::DataFlow
import codeql.ruby.dataflow.internal.DataFlowPrivate
import codeql.ruby.dataflow.internal.DataFlowImplConsistency::Consistency

private class MyConsistencyConfiguration extends ConsistencyConfiguration {
  override predicate postWithInFlowExclude(Node n) { n instanceof SummaryNode }

  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    n instanceof BlockArgumentNode
    or
    n instanceof SummaryNode
    or
    n instanceof SynthHashSplatArgumentNode
    or
    not isNonConstantExpr(getAPostUpdateNodeForArg(n.asExpr()))
  }

  override predicate postHasUniquePreExclude(PostUpdateNode n) {
    exists(CfgNodes::ExprCfgNode e, CfgNodes::ExprCfgNode arg |
      e = getAPostUpdateNodeForArg(arg) and
      e != arg and
      n = TExprPostUpdateNode(e)
    )
  }

  override predicate uniquePostUpdateExclude(Node n) {
    exists(CfgNodes::ExprCfgNode e, CfgNodes::ExprCfgNode arg |
      e = getAPostUpdateNodeForArg(arg) and
      e != arg and
      n.asExpr() = arg
    )
  }
}
