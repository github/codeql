import codeql.ruby.DataFlow::DataFlow as DataFlow
private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.internal.DataFlowImplSpecific
private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<RubyDataFlow> {
  private import RubyDataFlow

  predicate postWithInFlowExclude(Node n) { n instanceof FlowSummaryNode }

  predicate argHasPostUpdateExclude(ArgumentNode n) {
    n instanceof BlockArgumentNode
    or
    n instanceof FlowSummaryNode
    or
    n instanceof SynthHashSplatArgumentNode
    or
    not isNonConstantExpr(getAPostUpdateNodeForArg(n.asExpr()))
  }

  predicate postHasUniquePreExclude(PostUpdateNode n) {
    exists(CfgNodes::ExprCfgNode e, CfgNodes::ExprCfgNode arg |
      e = getAPostUpdateNodeForArg(arg) and
      e != arg and
      n = TExprPostUpdateNode(e)
    )
  }

  predicate uniquePostUpdateExclude(Node n) {
    exists(CfgNodes::ExprCfgNode e, CfgNodes::ExprCfgNode arg |
      e = getAPostUpdateNodeForArg(arg) and
      e != arg and
      n.asExpr() = arg
    )
  }
}

import MakeConsistency<RubyDataFlow, RubyTaintTracking, Input>

query predicate multipleToString(DataFlow::Node n, string s) {
  s = strictconcat(n.toString(), ",") and
  strictcount(n.toString()) > 1
}
