private import AstImport

/** Gets the enclosing scope of `n`. */
Scope scopeOf(Ast n) {
  exists(Ast m | m = n.getParent() |
    m = result
    or
    not m instanceof Scope and result = scopeOf(m)
  )
}

class Scope extends Ast {
  Scope() { getRawAst(this) instanceof Raw::Scope }

  /** Gets the outer scope, if any. */
  Scope getOuterScope() { result = scopeOf(this) }

  UsingStmt getAnActiveUsingStmt() { result.getAnAffectedScope() = this }
}

module Scope {
  class Range extends Raw::Scope { }
}
