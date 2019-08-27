import semmle.code.cpp.Type

pragma[noinline]
private string getTopLevelClassName(@usertype c) {
  isClass(c) and
  usertypes(c, result, _) and
  not namespacembrs(_, c) and // not in a namespace
  not member(_, _, c) and // not in some structure
  not class_instantiation(c, _) // not a template instantiation
}

/** Holds if `d` is a unique complete class named `name`. */
pragma[noinline]
private predicate existsCompleteWithName(string name, @usertype d) {
  is_complete(d) and
  name = getTopLevelClassName(d) and
  onlyOneCompleteClassExistsWithName(name)
}

pragma[noinline]
private predicate onlyOneCompleteClassExistsWithName(string name) {
  strictcount(@usertype c | is_complete(c) and getTopLevelClassName(c) = name) = 1
}

/** Holds if `c` is an incomplete class named `name`. */
pragma[noinline]
private predicate existsIncompleteWithName(string name, @usertype c) {
  not is_complete(c) and
  name = getTopLevelClassName(c)
}

/**
 * Holds if `c` is an incomplete class, and there exists a unique complete class `d`
 * with the same name.
 */
private predicate hasCompleteTwin(@usertype c, @usertype d) {
  exists(string name |
    existsIncompleteWithName(name, c) and
    existsCompleteWithName(name, d)
  )
}

import Cached
cached private module Cached {
  /**
   * If `c` is incomplete, and there exists a unique complete class with the same name,
   * then the result is that complete class. Otherwise, the result is `c`.
   */
  cached @usertype resolveClass(@usertype c) {
    hasCompleteTwin(c, result)
    or
    (not hasCompleteTwin(c, _) and result = c)
  }

  /**
   * Holds if `t` is a struct, class, union, or template.
   */
  cached predicate isClass(@usertype t) {
    (usertypes(t,_,1) or usertypes(t,_,2) or usertypes(t,_,3) or usertypes(t,_,6)
    or usertypes(t,_,10) or usertypes(t,_,11) or usertypes(t,_,12))
  }

  cached predicate isType(@type t) {
    not isClass(t)
    or
    t = resolveClass(_)
  }
}
