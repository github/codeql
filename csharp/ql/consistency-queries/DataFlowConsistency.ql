import csharp
import cil
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<CsharpDataFlow> {
  private import CsharpDataFlow

  predicate uniqueEnclosingCallableExclude(Node n) {
    // TODO: Remove once static initializers are folded into the
    // static constructors
    exists(ControlFlow::Node cfn |
      cfn.getAstNode() = any(FieldOrProperty f | f.isStatic()).getAChild+() and
      cfn = n.getControlFlowNode()
    )
  }

  predicate uniqueCallEnclosingCallableExclude(DataFlowCall call) {
    // TODO: Remove once static initializers are folded into the
    // static constructors
    exists(ControlFlow::Node cfn |
      cfn.getAstNode() = any(FieldOrProperty f | f.isStatic()).getAChild+() and
      cfn = call.getControlFlowNode()
    )
  }

  predicate uniqueNodeLocationExclude(Node n) {
    // Methods with multiple implementations
    n instanceof ParameterNode
    or
    missingLocationExclude(n)
  }

  predicate missingLocationExclude(Node n) {
    // Some CIL methods are missing locations
    n.asParameter() instanceof CIL::Parameter
  }

  predicate postWithInFlowExclude(Node n) {
    n instanceof FlowSummaryNode
    or
    n.asExpr().(ObjectCreation).hasInitializer()
  }

  predicate argHasPostUpdateExclude(ArgumentNode n) {
    n instanceof FlowSummaryNode
    or
    not exists(LocalFlow::getAPostUpdateNodeForArg(n.getControlFlowNode()))
    or
    n instanceof ImplicitCapturedArgumentNode
    or
    n instanceof ParamsArgumentNode
    or
    n.asExpr() instanceof CIL::Expr
  }

  predicate postHasUniquePreExclude(PostUpdateNode n) {
    exists(ControlFlow::Nodes::ExprNode e, ControlFlow::Nodes::ExprNode arg |
      e = LocalFlow::getAPostUpdateNodeForArg(arg) and
      e != arg and
      n = TExprPostUpdateNode(e)
    )
  }

  predicate uniquePostUpdateExclude(Node n) {
    exists(ControlFlow::Nodes::ExprNode e, ControlFlow::Nodes::ExprNode arg |
      e = LocalFlow::getAPostUpdateNodeForArg(arg) and
      e != arg and
      n.asExpr() = arg.getExpr()
    )
  }

  predicate reverseReadExclude(Node n) { n.asExpr() = any(AwaitExpr ae).getExpr() }
}

import MakeConsistency<CsharpDataFlow, CsharpTaintTracking, Input>

query predicate multipleToString(DataFlow::Node n, string s) {
  s = strictconcat(n.toString(), ",") and
  strictcount(n.toString()) > 1
}
