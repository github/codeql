/**
 * Provides predicates for working with the DOM type hierarchy.
 */

import semmle.javascript.Externs

/** Holds if `et` is a root interface of the DOM type hierarchy. */
predicate isDOMRootType(ExternalType et) {
  exists(string n | n = et.getName() | n = "EventTarget" or n = "StyleSheet")
}

/** Holds if `p` is declared as a property of a DOM class or interface. */
pragma[nomagic]
predicate isDOMProperty(string p) {
  exists(ExternalMemberDecl emd | emd.getName() = p |
    isDOMRootType(emd.getDeclaringType().getASupertype*())
  )
}
