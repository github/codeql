private import Raw

class ScriptBlockExpr extends @script_block_expression, Expr {
  override SourceLocation getLocation() { script_block_expression_location(this, result) }

  ScriptBlock getBody() { script_block_expression(this, result) }

  final override Ast getChild(ChildIndex i) { i = ScriptBlockExprBody() and result = this.getBody() }
}
