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

  predicate missingArgumentCallExclude(ArgumentNode arg) {
    // TODO: Remove once object initializers are modeled properly
    arg.(Private::PostUpdateNodes::ObjectInitializerNode).getInitializer() instanceof
      ObjectInitializer
    or
    // TODO: Remove once underlying issue is fixed
    exists(QualifiableExpr qe |
      qe.isConditional() and
      qe.getQualifier() = arg.asExpr()
    )
  }

  predicate multipleArgumentCallExclude(ArgumentNode arg, DataFlowCall call) {
    isArgumentNode(arg, call, _) and
    (
      // TODO: Remove once object initializers are modeled properly
      arg =
        any(Private::PostUpdateNodes::ObjectInitializerNode init |
          init.argumentOf(call, _) and
          init.getInitializer().getNumberOfChildren() > 1
        )
      or
      exists(ControlFlow::Nodes::ElementNode cfn, ControlFlow::Nodes::Split split |
        exists(arg.asExprAtNode(cfn))
      |
        split = cfn.getASplit() and
        not split = call.getControlFlowNode().getASplit()
        or
        split = call.getControlFlowNode().getASplit() and
        not split = cfn.getASplit()
      )
      or
      call instanceof TransitiveCapturedDataFlowCall
      or
      call.(NonDelegateDataFlowCall).getDispatchCall().isReflection()
    )
  }
}

import MakeConsistency<CsharpDataFlow, CsharpTaintTracking, Input>
