/**
 * Provides Swift-specific data flow rules.
 */

private import unified
private import AllDataFlow

private class SwiftDataFlowPlugin extends DataFlowPlugin {
  // Note: For now we assume all code is Swift, but in the future we must restrict these rules to Swift-files
  override predicate step(BuilderNode node1, Step step, BuilderNode node2) {
    exists(BinaryExpr expr |
      expr.getOperator().getValue() = ["+", "+="] and
      node1.isResultValue([expr.getLeft(), expr.getRight()]) and
      step.taint() and
      node2.isResultValue(expr)
    )
    or
    exists(CallExpr call |
      // String interpolations in Swift currently insert a call to a built-in called "interpolation".
      // Add taint through plain 1-argument calls to this built-in.
      call.getCallee().(BuiltinExpr).getValue() = "interpolation" and
      call.getNumberOfArguments() = 1 and
      not exists(call.getArgument(0).getName()) and
      node1.isResultValue(call.getArgument(0).getValue()) and
      step.value() and
      node2.isResultValue(call)
    )
    or
    exists(UnaryExpr expr |
      expr.getOperator().(PostfixOperator).getValue() = "!" and
      node1.isResultValue(expr.getOperand()) and
      (step.readName("some.0") or step.taint()) and
      node2.isResultValue(expr)
      or
      expr.getOperator().(PrefixOperator).getValue() = ["try", "try!", "await"] and
      node1.isResultValue(expr.getOperand()) and
      step.value() and
      node2.isResultValue(expr)
      or
      expr.getOperator().(PrefixOperator).getValue() = "try?" and
      // TODO: preserve the value of some.0 if it is already stored in that
      node1.isResultValue(expr.getOperand()) and
      step.storeName("some.0") and
      node2.isResultValue(expr)
    )
    or
    exists(TypeCastExpr expr |
      // The `as?` type cast boxes the incoming value in Optional depending on whether the type cast succeeded
      expr.getOperator().getValue() = "as?" and
      node1.isResultValue(expr.getExpr()) and
      step.storeName("some.0") and
      node2.isResultValue(expr)
      or
      // Safe upcast conversion ("as") and downcast-or-throw ("as!") propagate the value directly
      expr.getOperator().getValue() = ["as", "as!"] and
      node1.isResultValue(expr.getExpr()) and
      step.value() and
      node2.isResultValue(expr)
    )
    or
    // Taint flow through URL(string: x). TODO: Model with MaD and flow summaries
    exists(CallExpr call |
      call.getCallee().(Identifier).getValue() = ["URL", "NSURL"] and
      node1.isResultValue(call.getNamedArgument("string")) and
      step.taint() and
      node2.isResultValue(call)
    )
    or
    exists(UnaryExpr expr |
      // The AST mapping translates `[weak x]` into `[x = weak x]`.
      // Model the `weak` UnaryExpr as a store into `Optional.some`.
      expr.getOperator().(PrefixOperator).getValue() = "weak" and
      node1.isResultValue(expr.getOperand()) and
      step.storeName("some.0") and
      node2.isResultValue(expr)
    )
  }
}
