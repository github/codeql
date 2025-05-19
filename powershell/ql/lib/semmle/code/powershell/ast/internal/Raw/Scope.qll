private import Raw

/** Gets the enclosing scope of `n`. */
Scope scopeOf(Ast n) {
  exists(Ast m | m = n.getParent() |
    m = result
    or
    not m instanceof Scope and result = scopeOf(m)
  )
}

abstract private class ScopeImpl extends Ast {
  abstract Scope getOuterScopeImpl();

  abstract Ast getParameterImpl(int index);
}

class Scope instanceof ScopeImpl {
  Scope getOuterScope() { result = super.getOuterScopeImpl() }

  string toString() { result = super.toString() }

  Parameter getParameter(int index) { result = super.getParameterImpl(index) }

  Parameter getAParameter() { result = this.getParameter(_) }

  Location getLocation() { result = super.getLocation() }
}

/**
 * A variable scope. This is either a top-level (file), a module, a class,
 * or a callable.
 */
private class ScriptBlockScope extends ScopeImpl instanceof ScriptBlock {
  /** Gets the outer scope, if any. */
  override Scope getOuterScopeImpl() { result = scopeOf(this) }

  override Parameter getParameterImpl(int index) {
    exists(ParamBlock pb |
      pb.getParameter(index) = result and
      pb.getScriptBlock() = this
    )
    or
    exists(FunctionDefinitionStmt func |
      func.getParameter(index) = result and
      func.getBody() = this
    )
  }
}
