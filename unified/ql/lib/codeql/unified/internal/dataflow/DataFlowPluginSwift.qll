/**
 * Provides Swift-specific data flow rules.
 */

private import unified
private import AllDataFlow

private class SwiftDataFlowPlugin extends DataFlowPlugin {
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
  }
}
