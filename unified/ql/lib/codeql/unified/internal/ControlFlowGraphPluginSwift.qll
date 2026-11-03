private import unified
private import ControlFlowGraphPlugin

private predicate inTry(AstNode ast) {
  ast.(UnaryExpr).getOperator().(Token).getValue() = "try"
  or
  exists(AstNode parent |
    parent = ast.getParent() and
    inTry(ast.getParent()) and
    not parent instanceof Callable
  )
}

private class ControlFlowGraphPluginSwift extends ControlFlowGraphPlugin {
  override predicate mayThrow(AstNode ast) { ast instanceof CallExpr and inTry(ast) }
}
