import csharp
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, CsharpDataFlow> {
  private import CsharpDataFlow

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
    or
    n.(PostUpdateNode).getPreUpdateNode().asExpr() = LocalFlow::getPostUpdateReverseStep(_)
  }

  predicate argHasPostUpdateExclude(ArgumentNode n) {
    n instanceof FlowSummaryNode
    or
    n instanceof ParamsArgumentNode
    or
    n.asExpr() = any(Expr e | not exprMayHavePostUpdateNode(e))
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
      call.(NonDelegateDataFlowCall).getDispatchCall().isReflection()
      or
      // Exclude calls that are both getter and setter calls, as they share the same argument nodes.
      exists(AccessorCall ac |
        call.(NonDelegateDataFlowCall).getDispatchCall().getCall() = ac and
        ac instanceof AssignableRead and
        ac instanceof AssignableWrite
      )
    )
  }
}

import MakeConsistency<Location, CsharpDataFlow, CsharpTaintTracking, Input>
