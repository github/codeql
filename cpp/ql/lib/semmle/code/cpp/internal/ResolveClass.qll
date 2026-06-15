import semmle.code.cpp.Type

pragma[noinline]
private @mangledname getClassMangledName(@usertype c) {
  isClass(c) and
  mangled_name(c, result, _)
}

/** Holds if `d` is a unique complete class named `name`. */
pragma[noinline]
private predicate existsCompleteWithMangledName(@mangledname name, @usertype d) {
  is_complete(d) and
  name = getClassMangledName(d) and
  onlyOneCompleteClassExistsWithMangledName(name)
}

pragma[noinline]
private predicate onlyOneCompleteClassExistsWithMangledName(@mangledname name) {
  strictcount(@usertype c | is_complete(c) and getClassMangledName(c) = name) = 1
}

/** Holds if `c` is an incomplete class named `name`. */
pragma[noinline]
private predicate existsIncompleteWithMangledName(@mangledname name, @usertype c) {
  not is_complete(c) and
  name = getClassMangledName(c)
}

/**
 * Holds if `c` is an incomplete class, and there exists a unique complete class `d`
 * with the same name.
 */
private predicate hasCompleteTwin(@usertype c, @usertype d) {
  exists(@mangledname name |
    existsIncompleteWithMangledName(name, c) and
    existsCompleteWithMangledName(name, d)
  )
}

import Cached

cached
private module Cached {
  /**
   * If `c` is incomplete, and there exists a unique complete class with the same name,
   * then the result is that complete class. Otherwise, the result is `c`.
   */
  cached
  @usertype resolveClass(@usertype c) {
    hasCompleteTwin(c, result)
    or
    not hasCompleteTwin(c, _) and
    result = c
  }

  /**
   * Holds if `t` is a struct, class, union, or template.
   */
  cached
  predicate isClass(@usertype t) { usertypes(t, _, [1, 2, 3, 15, 16, 17]) }

  cached
  predicate isType(@type t) {
    not isClass(t)
    or
    t = resolveClass(_)
  }
}
