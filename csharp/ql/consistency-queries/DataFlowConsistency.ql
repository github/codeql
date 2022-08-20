import csharp
import cil
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DataFlowPublic
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
    n.asExpr().(Expr).stripCasts().getType() =
      any(Type t |
        not t instanceof RefType and
        not t = any(TypeParameter tp | not tp.isValueType())
        or
        t instanceof NullType
      )
    or
    n instanceof ImplicitCapturedArgumentNode
    or
    n instanceof ParamsArgumentNode
    or
    n.asExpr() instanceof CIL::Expr
  }

  override predicate reverseReadExclude(Node n) { n.asExpr() = any(AwaitExpr ae).getExpr() }
}
