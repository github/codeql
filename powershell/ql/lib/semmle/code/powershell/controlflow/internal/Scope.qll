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

  /**
   * Gets the `i`'th paramter in this scope.
   *
   * This may be both function paramters and parameter block parameters.
   */
  Parameter getParameter(int i) {
    exists(Function func |
      func.getBody() = this and
      result = func.getParameter(i)
    )
  }

  /**
   * Gets a paramter in this scope.
   *
   * This may be both function paramters and parameter block parameters.
   */
  Parameter getAParameter() { result = this.getParameter(_) }

  Parameter getThisParameter() {
    exists(Function func |
      func.getBody() = this and
      result = func.getThisParameter()
    )
  }
}
