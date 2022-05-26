/**
 * Provides predicates for working with the DOM type hierarchy.
 */

import semmle.javascript.Externs

/** DEPRECATED: Alias for isDomRootType */
deprecated predicate isDOMRootType = isDomRootType/1;

/** Holds if `p` is declared as a property of a DOM class or interface. */
pragma[nomagic]
predicate isDomProperty(string p) {
  exists(ExternalMemberDecl emd | emd.getName() = p |
    isDomRootType(emd.getDeclaringType().getASupertype*())
  )
}

/** DEPRECATED: Alias for isDomProperty */
deprecated predicate isDOMProperty = isDomProperty/1;
