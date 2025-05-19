private import AstImport

class DynamicStmt extends Stmt, TDynamicStmt {
  override string toString() { result = "&..." }

  Expr getName() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, dynamicStmtName(), result)
      or
      not synthChild(r, dynamicStmtName(), _) and
      result = getResultAst(r.(Raw::DynamicStmt).getName())
    )
  }

  ScriptBlockExpr getScriptBlock() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, dynamicStmtBody(), result)
      or
      not synthChild(r, dynamicStmtBody(), _) and
      result = getResultAst(r.(Raw::DynamicStmt).getScriptBlock())
    )
  }

  HashTableExpr getHashTableExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, dynamicStmtBody(), result)
      or
      not synthChild(r, dynamicStmtBody(), _) and
      result = getResultAst(r.(Raw::DynamicStmt).getHashTableExpr())
    )
  }

  predicate hasScriptBlock() { exists(this.getScriptBlock()) }

  predicate hasHashTableExpr() { exists(this.getHashTableExpr()) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = dynamicStmtName() and result = this.getName()
    or
    i = dynamicStmtBody() and
    (result = this.getScriptBlock() or result = this.getHashTableExpr())
  }
}
