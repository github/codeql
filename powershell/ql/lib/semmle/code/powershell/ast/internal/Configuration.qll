private import AstImport

class Configuration extends Stmt, TConfiguration {
  override string toString() { result = this.getName().toString() }

  Expr getName() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, configurationName(), result)
      or
      not synthChild(r, configurationName(), _) and
      result = getResultAst(r.(Raw::Configuration).getName())
    )
  }

  ScriptBlockExpr getBody() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, configurationBody(), result)
      or
      not synthChild(r, configurationBody(), _) and
      result = getResultAst(r.(Raw::Configuration).getBody())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = configurationName() and result = this.getName()
    or
    i = configurationBody() and result = this.getBody()
  }
}
