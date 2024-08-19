private import powershell
private import ControlFlowGraphImpl

/** Gets the enclosing scope of `n`. */
Scope scopeOf(Ast n) {
  exists(Ast m | m = n.getParent() |
    m = result
    or
    not m instanceof Scope and result = scopeOf(m)
  )
}

/**
 * A variable scope. This is either a top-level (file), a module, a class,
 * or a callable.
 */
class Scope extends Ast, @script_block {
  /** Gets the outer scope, if any. */
  Scope getOuterScope() { result = scopeOf(this) }
}
