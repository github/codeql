/**
 * Provides Swift-specific data flow rules.
 */

private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions
private import codeql.unified.internal.typeinference.TypeInference as T

private class SwiftDataFlowPlugin extends DataFlowPlugin {
  // Note: For now we assume all code is Swift, but in the future we must restrict these rules to Swift-files
  override predicate bypassContentSet(ContentSet contents) {
    contents.asSingleton().asNamedMember() = "some.0"
  }

  // Swift writes back mutated values of computed value-type properties via their setter
  bindingset[expr]
  override predicate mayWriteBackViaSetterCall(Expr expr) {
    isInWriteBackPosition(expr) and
    // conservative value-type check
    not forex(T::Type t | t = T::inferType(expr) | t.asClass().hasModifier("class"))
  }

  override predicate exprStep(Expr expr1, Expr expr2, boolean mustFlow) {
    mustFlow = true and
    exists(UnaryExpr expr |
      expr.getOperator().(PrefixOperator).getValue() = "&"
      or
      expr.getOperator().(PostfixOperator).getValue() = "!"
    |
      expr1 = expr.getOperand() and
      expr2 = expr
    )
    or
    mustFlow = true and
    exists(TypeCastExpr expr |
      // Type-cast operators:
      // - "as": Safe upcast conversion
      // - "as?": Wrap in Optional<T> if cast succeeds
      // - "as!": Throw if cast fails
      //
      // Since we bypass Optional<T> content, we model all of these as must-flow steps.
      expr.getOperator().getValue() = ["as", "as?", "as!"] and
      expr1 = expr.getExpr() and
      expr2 = expr
    )
  }

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
      expr.getOperator().(PrefixOperator).getValue() = ["try", "try!", "try?", "await"] and
      node1.isResultValue(expr.getOperand()) and
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
    or
    // Singleton blocks propagate their value upwards, e.g. in `if expr { expr } else { expr }`
    exists(Block block |
      not exists(block.getStmt(1)) and
      node1.isResultValue(block.getStmt(0)) and
      step.value() and
      node2.isResultValue(block)
    )
  }
}

/**
 * Holds if `expr` is target of an assignment or 'inout' argument,
 * or the base of such an expression, e.g. `x` in `x.f1.f2 = foo()`
 */
private predicate isInWriteBackPosition(Expr expr) {
  isInAssignmentContext(expr, _)
  or
  // Arguments to an 'inout' parameter must be prefixed with '&'
  exists(UnaryExpr unary |
    unary.getOperator().(PrefixOperator).getValue() = "&" and
    unary.getOperand() = expr
    // TODO: support custom operators with an 'inout' parameter, which lack the '&' indicator
  )
  or
  // The receiver of a call to a 'mutating' function counts as an 'inout' argument
  exists(CallExpr call, Callable target |
    target = T::resolveCallTarget(call) and
    target.hasModifier("mutating") and
    expr = call.getCallee().(MemberAccessExpr).getBase()
  )
  or
  exists(MemberAccessExpr member |
    isInWriteBackPosition(member) and
    expr = member.getBase()
  )
}
