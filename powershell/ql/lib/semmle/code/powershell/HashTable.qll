import powershell

class HashTableExpr extends @hash_table, Expr {
  final override Location getLocation() { hash_table_location(this, result) }

  final override string toString() { result = "${...}" }

  Stmt getExprWithKey(Expr key) { hash_table_key_value_pairs(this, _, key, result) } // TODO: Change @ast to @expr in db scheme

  predicate hasKey(Expr key) { exists(this.getExprWithKey(key)) }

  Stmt getAnExpr() { result = this.getExprWithKey(_) }

  predicate hasEntry(int index, Expr key, Stmt value) {
    hash_table_key_value_pairs(this, index, key, value)
  }
}
