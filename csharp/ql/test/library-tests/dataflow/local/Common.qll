import csharp

class MyFlowSource extends DataFlow::Node {
  MyFlowSource() {
    exists(Expr e |
      e = this.asExpr() |
      e.(StringLiteral).getValue() = "taint source" or
      e.(VariableAccess).getTarget().hasName("taintedDataContract") or
      e.(VariableAccess).getTarget().hasName("taintedHttpRequest") or
      e.(VariableAccess).getTarget().hasName("taintedTextBox")
    )
    or
    this.asParameter().hasName("tainted")
    or
    exists(Expr e |
      e = this.(DataFlow::Internal::ImplicitDelegateCallNode).getArgument() |
      e.(DelegateCreation).getArgument().(MethodAccess).getTarget().hasName("TaintedMethod") or
      e.(LambdaExpr).getExpressionBody().(StringLiteral).getValue() = "taint source"
    )
  }
}
