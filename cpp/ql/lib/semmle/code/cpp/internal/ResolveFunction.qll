private predicate hasDefinition(@function f) {
  exists(@fun_decl fd | fun_decls(fd, f, _, _, _) | fun_def(fd))
}

private predicate onlyOneCompleteFunctionExistsWithMangledName(@mangledname name) {
  strictcount(@function f | hasDefinition(f) and mangled_name(f, name, true)) = 1
}

/** Holds if `f` is a unique function with a definition named `name`. */
private predicate isFunctionWithMangledNameAndWithDefinition(@mangledname name, @function f) {
  hasDefinition(f) and
  mangled_name(f, name, true) and
  onlyOneCompleteFunctionExistsWithMangledName(name)
}

/** Holds if `f` is a function without a definition named `name`. */
private predicate isFunctionWithMangledNameAndWithoutDefinition(@mangledname name, @function f) {
  not hasDefinition(f) and
  mangled_name(f, name, true)
}

/**
 * Holds if `incomplete` is a function without a definition, and there exists
 * a unique function `complete` with the same name that does have a definition.
 */
private predicate hasTwinWithDefinition(@function incomplete, @function complete) {
  not function_instantiation(incomplete, complete) and
  (
    not compgenerated(incomplete) or
    not compgenerated(complete)
  ) and
  exists(@mangledname name |
    isFunctionWithMangledNameAndWithoutDefinition(name, incomplete) and
    isFunctionWithMangledNameAndWithDefinition(name, complete)
  )
}

import Cached

cached
private module Cached {
  /**
   * If `f` is a function without a definition, and there exists a unique
   * function with the same name that does have a definition, then the
   * result is that unique function. Otherwise, the result is `f`.
   */
  cached
  @function resolveFunction(@function f) {
    hasTwinWithDefinition(f, result)
    or
    not hasTwinWithDefinition(f, _) and
    result = f
  }

  cached
  predicate isFunction(@function f) { f = resolveFunction(_) }
}
