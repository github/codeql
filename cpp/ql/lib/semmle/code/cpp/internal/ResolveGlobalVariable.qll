private predicate hasDefinition(@globalvariable g) {
  exists(@var_decl vd | var_decls(vd, g, _, _, _) | var_def(vd))
}

private predicate onlyOneCompleteGlobalVariableExistsWithMangledName(@mangledname name) {
  strictcount(@globalvariable g | hasDefinition(g) and mangled_name(g, name, _)) = 1
}

/** Holds if `g` is a unique global variable with a definition named `name`. */
private predicate isGlobalWithMangledNameAndWithDefinition(@mangledname name, @globalvariable g) {
  hasDefinition(g) and
  mangled_name(g, name, _) and
  onlyOneCompleteGlobalVariableExistsWithMangledName(name)
}

/** Holds if `g` is a global variable without a definition named `name`. */
private predicate isGlobalWithMangledNameAndWithoutDefinition(@mangledname name, @globalvariable g) {
  not hasDefinition(g) and
  mangled_name(g, name, _)
}

/**
 * Holds if `incomplete` is a global variable without a definition, and there exists
 * a unique global variable `complete` with the same name that does have a definition.
 */
private predicate hasTwinWithDefinition(@globalvariable incomplete, @globalvariable complete) {
  not variable_instantiation(incomplete, complete) and
  exists(@mangledname name |
    isGlobalWithMangledNameAndWithoutDefinition(name, incomplete) and
    isGlobalWithMangledNameAndWithDefinition(name, complete)
  )
}

import Cached

cached
private module Cached {
  /**
   * If `v` is a global variable without a definition, and there exists a unique
   * global variable with the same name that does have a definition, then the
   * result is that unique global variable. Otherwise, the result is `v`.
   */
  cached
  @variable resolveGlobalVariable(@variable v) {
    hasTwinWithDefinition(v, result)
    or
    not hasTwinWithDefinition(v, _) and
    result = v
  }

  cached
  predicate isVariable(@variable v) {
    not v instanceof @globalvariable
    or
    v = resolveGlobalVariable(_)
  }
}
