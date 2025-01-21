import rust

/**
 * A deliberately unused variable, for example `_` or `_x`.
 */
class DiscardVariable extends Variable {
  DiscardVariable() { this.getName().charAt(0) = "_" }
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
 * Holds if variable `v` is in a context where we may not find a use for it,
 * but that's expected and should not be considered a problem.
 */
predicate isAllowableUnused(Variable v) {
  // in a macro expansion
  v.getPat().isInMacroExpansion()
  or
  // a 'self' variable
  v.getName() = "self"
}
