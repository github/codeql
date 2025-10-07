import rust

/**
 * A deliberately unused variable, for example `_` or `_x`.
 */
class DiscardVariable extends Variable {
  DiscardVariable() { this.getText().charAt(0) = "_" }
}

/**
 * Holds if variable `v` is unused.
 */
predicate isUnused(Variable v) {
  // variable is not accessed or initialized
  not exists(v.getAnAccess()) and
  not exists(v.getInitializer())
}

/**
 * A callable for which we have incomplete information, for example because an unexpanded
 * macro call is present. These callables are prone to false positive results from unused
 * entities queries, unless they are excluded from results.
 */
class IncompleteCallable extends Callable {
  IncompleteCallable() {
    exists(MacroExpr me |
      me.getEnclosingCallable() = this and
      not me.getMacroCall().hasMacroCallExpansion()
    )
  }
}

/**
 * Holds if variable `v` is in a context where we may not find a use for it,
 * but that's expected and should not be considered a problem.
 */
predicate isAllowableUnused(Variable v) {
  // in a macro expansion
  v.getPat().isInMacroExpansion()
  or
  // declared in an incomplete callable
  v.getEnclosingCfgScope() instanceof IncompleteCallable
  or
  // a 'self' variable
  v.getText() = "self"
}
