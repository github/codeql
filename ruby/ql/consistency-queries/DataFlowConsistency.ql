import codeql.ruby.DataFlow::DataFlow as DataFlow
private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.internal.DataFlowImplSpecific
private import codeql.ruby.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, RubyDataFlow> {
  private import RubyDataFlow

  predicate postWithInFlowExclude(Node n) { n instanceof FlowSummaryNode }

  predicate argHasPostUpdateExclude(ArgumentNode n) {
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

  predicate multipleArgumentCallExclude(ArgumentNode arg, DataFlowCall call) {
    // An argument such as `x` in `if not x then ...` has two successors (and hence
    // two calls); one for each Boolean outcome of `x`.
    exists(CfgNodes::ExprCfgNode n |
      arg.argumentOf(call, _) and
      n = call.asCall() and
      arg.asExpr().getASuccessor(any(SuccessorTypes::ConditionalSuccessor c)).getASuccessor*() = n and
      n.getASplit() instanceof Split::ConditionalCompletionSplit
    )
  }

  predicate uniqueTypeExclude(Node n) {
    n =
      any(DataFlow::CallNode call |
        Private::isStandardNewCall(call.getExprNode(), _, _) and
        not call.getReceiver().asExpr().getExpr() instanceof ConstantReadAccess
      )
  }
}

import MakeConsistency<Location, RubyDataFlow, RubyTaintTracking, Input>
