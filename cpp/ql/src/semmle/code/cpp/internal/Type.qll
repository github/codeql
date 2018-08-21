import semmle.code.cpp.Type

/** Holds if `d` is a complete class named `name`. */
pragma[noinline]
private predicate existsCompleteWithName(string name, @usertype d) {
  isClass(d) and
  is_complete(d) and
  usertypes(d, name, _)
}

/** Holds if `c` is an incomplete class named `name`. */
pragma[noinline]
private predicate existsIncompleteWithName(string name, @usertype c) {
  isClass(c) and
  not is_complete(c) and
  usertypes(c, name, _)
}

/**
 * Holds if `c` is an imcomplete class, and there exists a complete class `d`
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
   * If `c` is incomplete, and there exists a complete class with the same name,
   * then the result is that complete class. Otherwise, the result is `c`. If
   * multiple complete classes have the same name, this predicate may have
   * multiple results.
   */
  cached @usertype resolve(@usertype c) {
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

  cached predicate isElement(@element e) {
    isClass(e) implies e = resolve(_)
  }
}
