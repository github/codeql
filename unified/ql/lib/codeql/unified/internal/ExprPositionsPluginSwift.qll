private import unified
private import ExprPositionsPlugin

private class ExprPositionsPluginSwift extends ExprPositionsPlugin {
  override predicate isInSyntacticTypeContext(Expr e) { e = any(GenericTypeExpr g).getBase() }

  override predicate isReturnedExpr(Callable callable, Expr e) {
    // Short-hand return from a function body, e.g. `func foo() -> String { "42" }`
    // This happens when the body contains a single expression and this expression resolves to a value.
    // We don't detect precisely whether the expression resolves to a value, but we restrict to cases
    // where a spurious return would be harmless in practice.
    (
      callable instanceof FunctionDeclaration and
      exists(Expr ret | ret = callable.getReturnType() | not ret.(Identifier).getValue() = "Void")
      or
      callable instanceof GetterDeclaration
      or
      callable instanceof FunctionExpr // We can't tell whether closures have a return value
    ) and
    exists(Block body |
      body = callable.getBody() and
      not exists(body.getStmt(1)) and // Check that only one statement exists
      e = body.getStmt(0)
    )
  }
}
