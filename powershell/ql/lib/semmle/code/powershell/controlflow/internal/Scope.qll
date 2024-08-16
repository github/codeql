private import powershell
private import ControlFlowGraphImpl

class TScopeType = @function_definition; // TODO: top-level definitions (including a single top-level scope)

abstract class ScopeImpl extends Ast, TScopeType {
  final Scope getOuterScopeImpl() {
    none() // TODO
  }
}

/**
 * A variable scope. This is either a top-level (file), a module, a class,
 * or a callable.
 */
class Scope extends Ast instanceof ScopeImpl {
  /** Gets the outer scope, if any. */
  Scope getOuterScope() { result = super.getOuterScopeImpl() }
}
