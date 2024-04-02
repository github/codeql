import csharp
private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, CsharpDataFlow> {
  private import CsharpDataFlow

  private predicate isStaticAssignable(Assignable a) { a.(Modifiable).isStatic() }

  predicate uniqueEnclosingCallableExclude(Node node) {
    // TODO: Remove once static initializers are folded into the
    // static constructors
    isStaticAssignable(ControlFlowGraphImpl::getNodeCfgScope(node.getControlFlowNode()))
  }

  predicate uniqueCallEnclosingCallableExclude(DataFlowCall call) {
    // TODO: Remove once static initializers are folded into the
    // static constructors
    isStaticAssignable(ControlFlowGraphImpl::getNodeCfgScope(call.getControlFlowNode()))
  }

  predicate uniqueNodeLocationExclude(Node n) {
    // Methods with multiple implementations
    n instanceof ParameterNode
    or
    missingLocationExclude(n)
    or
    n instanceof FlowInsensitiveFieldNode
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
    n instanceof ParamsArgumentNode
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
      call.(NonDelegateDataFlowCall).getDispatchCall().isReflection()
    )
  }
}

import MakeConsistency<Location, CsharpDataFlow, CsharpTaintTracking, Input>
