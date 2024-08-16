import powershell

class ScriptBlockExpr extends @script_block_expression, Expr {
  override SourceLocation getLocation() { script_block_expression_location(this, result) }

  override string toString() { result = "{...}" }

  ScriptBlock getBody() { script_block_expression(this, result) }
}
