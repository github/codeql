import rust

/** A deliberately unused variable. */
class DiscardVariable extends Variable {
  DiscardVariable() { this.getName().charAt(0) = "_" }
}

/** Holds if variable `v` is unused. */
predicate isUnused(Variable v) {
  not exists(v.getAnAccess()) and
  not exists(v.getInitializer()) and
  not v instanceof DiscardVariable and
  not v.getPat().isInMacroExpansion() and
  exists(File f | f.getBaseName() = "main.rs" | v.getLocation().getFile() = f) // temporarily severely limit results
}
