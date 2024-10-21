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

/**
 * Gets counts of abstract syntax tree inconsistencies of each type.
 */
int getAstInconsistencyCounts(string type) {
  // total results from all the AST consistency query predicates.
  type = "Multiple toStrings" and
  result = count(Element e | multipleToStrings(e, _) | e)
  or
  type = "Multiple locations" and
  result = count(Element e | multipleLocations(e) | e)
  or
  type = "Multiple primary QL classes" and
  result = count(Element e | multiplePrimaryQlClasses(e, _) | e)
  or
  type = "Multiple parents" and
  result = count(Element e | multipleParents(e, _) | e)
}
