import rust

/** A deliberately unused variable. */
class DiscardVariable extends Variable {
  DiscardVariable() { this.getName().charAt(0) = "_" }
}

/** Holds if variable `v` is unused. */
predicate isUnused(Variable v) {
  // variable is accessed or initialized
  not exists(v.getAnAccess()) and
  not exists(v.getInitializer()) and
  // variable is intentionally unused
  not v instanceof DiscardVariable and
  // variable is in a context where is may not have a use
  not v.getPat().isInMacroExpansion() and
  not exists(FnPtrType fp | fp.getParamList().getParam(_).getPat() = v.getPat())
}
