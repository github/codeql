import csharp
import semmle.code.csharp.controlflow.Guards
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
    exists(MyFlowSource mid, DataFlow::ExprNode e |
      TaintTracking::localTaintStep+(mid, e) and
      e.getExpr() = this.asExpr().(ArrayCreation).getInitializer().getAnElement()
    )
  }
}
