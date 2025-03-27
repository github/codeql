private import AstImport

class ScriptBlockExpr extends Expr, TScriptBlockExpr {
  override string toString() { result = "{...}" }

  ScriptBlock getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, scriptBlockExprBody(), result)
      or
      not synthChild(r, scriptBlockExprBody(), _) and
      result = getResultAst(r.(Raw::ScriptBlockExpr).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = scriptBlockExprBody() and result = this.getBody()
  }
}
