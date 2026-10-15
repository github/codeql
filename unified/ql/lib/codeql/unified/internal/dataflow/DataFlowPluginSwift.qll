/**
 * Provides Swift-specific data flow rules.
 */

private import unified
private import AllDataFlow

private class SwiftDataFlowPlugin extends DataFlowPlugin {
  override predicate bypassContentSet(ContentSet contents) {
    contents.asSingleton().asNamedMember() = "some.0"
  }

  // Note: For now we assume all code is Swift, but in the future we must restrict these rules to Swift-files
  override predicate step(Node node1, Step step, Node node2) {
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
      expr.getOperator().(PostfixOperator).getValue() = "!"
      or
      expr.getOperator().(PrefixOperator).getValue() = ["try", "try!", "try?", "await"]
    |
      node1.isResultValue(expr.getOperand()) and
      step.value() and
      node2.isResultValue(expr)
    )
    or
    exists(TypeCastExpr expr |
      // Type-cast operators:
      // - "as": Safe upcast conversion
      // - "as?": Wrap in Optional<T> if cast succeeds
      // - "as!": Throw if cast fails
      //
      // Since we bypass Optional<T> content, we model all of these as value steps.
      expr.getOperator().getValue() = ["as", "as?", "as!"] and
      node1.isResultValue(expr.getExpr()) and
      step.value() and
      node2.isResultValue(expr)
    )
    or
    exists(NullCoalescingExpr expr |
      // We bypass Optional<T> content so we add value-flow out of both operands of "??"
      node1.isResultValue(expr.getAnOperand()) and
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
  }
}
