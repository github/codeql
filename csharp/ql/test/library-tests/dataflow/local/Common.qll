import csharp
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate

class MyFlowSource extends DataFlow::Node {
  MyFlowSource() {
    exists(Expr e | e = this.asExpr() |
      e.(StringLiteral).getValue() = "taint source" or
      e.(VariableAccess).getTarget().hasName("taintedDataContract") or
      e.(VariableAccess).getTarget().hasName("taintedHttpRequest") or
      e.(VariableAccess).getTarget().hasName("taintedTextBox")
    )
    or
    this.asParameter().hasName("tainted")
    or
    exists(Expr e |
      this = DataFlowPrivateCached::TImplicitDelegateOutNode(e.getAControlFlowNode(), _)
    |
      e.(DelegateCreation).getArgument().(MethodAccess).getTarget().hasName("TaintedMethod") or
      e.(LambdaExpr).getExpressionBody().(StringLiteral).getValue() = "taint source"
    )
  }
}
