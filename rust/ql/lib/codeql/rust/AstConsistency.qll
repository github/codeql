/**
 * Provides classes for recognizing control flow graph inconsistencies.
 */

private import rust
private import codeql.rust.elements.internal.generated.ParentChild

/**
 * Holds if `e` has more than one `toString()` result.
 */
query predicate multipleToStrings(Element e, string s) {
  s = strictconcat(e.toString(), ", ") and
  strictcount(e.toString()) > 1
}

/**
 * Holds if `e` has more than one `Location`.
 */
query predicate multipleLocations(Locatable e) { strictcount(e.getLocation()) > 1 }

/**
 * Holds if `e` has more than one `getPrimaryQlClasses()` result.
 */
query predicate multiplePrimaryQlClasses(Element e, string s) {
  s = strictconcat(e.getPrimaryQlClasses(), ", ") and
  strictcount(e.getAPrimaryQlClass()) > 1
}

private Element getParent(Element child) { child = getChildAndAccessor(result, _, _) }

/**
 * Holds if `child` has more than one AST parent.
 */
query predicate multipleParents(Element child, Element parent) {
  parent = getParent(child) and
  strictcount(getParent(child)) > 1
}
