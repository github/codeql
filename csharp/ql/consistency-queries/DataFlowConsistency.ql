import csharp
import cil
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DataFlowPublic
import semmle.code.csharp.dataflow.internal.DataFlowDispatch
import semmle.code.csharp.dataflow.internal.DataFlowImplConsistency::Consistency

private class MyConsistencyConfiguration extends ConsistencyConfiguration {
  override predicate uniqueEnclosingCallableExclude(Node n) {
    // TODO: Remove once static initializers are folded into the
    // static constructors
    exists(ControlFlow::Node cfn |
      cfn.getElement() = any(FieldOrProperty f | f.isStatic()).getAChild+() and
      cfn = n.getControlFlowNode()
    )
  }

  override predicate uniqueCallEnclosingCallableExclude(DataFlowCall call) {
    // TODO: Remove once static initializers are folded into the
    // static constructors
    exists(ControlFlow::Node cfn |
      cfn.getElement() = any(FieldOrProperty f | f.isStatic()).getAChild+() and
      cfn = call.getControlFlowNode()
    )
  }

  override predicate uniqueNodeLocationExclude(Node n) {
    // Methods with multiple implementations
    n instanceof ParameterNode
    or
    this.missingLocationExclude(n)
  }

  override predicate missingLocationExclude(Node n) {
    // Some CIL methods are missing locations
    n.asParameter() instanceof CIL::Parameter
  }

  override predicate postWithInFlowExclude(Node n) {
    n instanceof SummaryNode
    or
    n.asExpr().(ObjectCreation).hasInitializer()
  }

  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    n instanceof SummaryNode
    or
    not exists(LocalFlow::getAPostUpdateNodeForArg(n.getControlFlowNode()))
    or
    n instanceof ImplicitCapturedArgumentNode
    or
    n instanceof ParamsArgumentNode
    or
    n.asExpr() instanceof CIL::Expr
  }

  override predicate postHasUniquePreExclude(PostUpdateNode n) {
    exists(ControlFlow::Nodes::ExprNode e, ControlFlow::Nodes::ExprNode arg |
      e = LocalFlow::getAPostUpdateNodeForArg(arg) and
      e != arg and
      n = TExprPostUpdateNode(e)
    )
  }

  override predicate uniquePostUpdateExclude(Node n) {
    exists(ControlFlow::Nodes::ExprNode e, ControlFlow::Nodes::ExprNode arg |
      e = LocalFlow::getAPostUpdateNodeForArg(arg) and
      e != arg and
      n.asExpr() = arg.getExpr()
    )
  }

  override predicate reverseReadExclude(Node n) { n.asExpr() = any(AwaitExpr ae).getExpr() }
}
