private import AstImport

class HashTableExpr extends Expr, THashTableExpr {
  final override string toString() { result = "${...}" }

  Expr getKey(int i) {
    exists(ChildIndex index, Raw::Ast r | index = hashTableExprKey(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::HashTableExpr).getKey(i))
    )
  }

  Expr getAKey() { result = this.getKey(_) }

  Expr getValue(int i) {
    exists(ChildIndex index, Raw::Ast r | index = hashTableExprStmt(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::HashTableExpr).getStmt(i))
    )
  }

  Expr getValueFromKey(Expr key) {
    exists(int i |
      this.getKey(i) = key and
      result = this.getValue(i)
    )
  }

  Expr getAValue() { result = this.getValue(_) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = hashTableExprKey(index) and
      result = this.getKey(index)
      or
      i = hashTableExprStmt(index) and
      result = this.getValue(index)
    )
  }

  predicate hasEntry(int i, Expr key, Expr value) {
    this.getKey(i) = key and
    this.getValue(i) = value
  }
}
