private import Raw

class HashTableExpr extends @hash_table, Expr {
  final override Location getLocation() { hash_table_location(this, result) }

  Expr getKey(int i) { hash_table_key_value_pairs(this, i, result, _) }

  Expr getAKey() { result = this.getKey(_) }

  Stmt getStmt(int i) { hash_table_key_value_pairs(this, i, _, result) }

  Stmt getAStmt() { result = this.getStmt(_) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = HashTableExprKey(index) and
      result = this.getKey(index)
      or
      i = HashTableExprStmt(index) and
      result = this.getStmt(index)
    )
  }
}
