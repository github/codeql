/**
 * Provides classes for recognizing control flow graph inconsistencies.
 */

private import rust
private import codeql.rust.elements.internal.generated.ParentChild

private predicate multipleToStrings(Element e) { strictcount(e.toString()) > 1 }

/**
 * Holds if `e` has more than one `toString()` result.
 */
query predicate multipleToStrings(Element e, string cls, string s) {
  multipleToStrings(e) and
  cls = e.getPrimaryQlClasses() and
  s = strictconcat(e.toString(), ", ")
}

/**
 * Holds if `e` has more than one `Location`.
 */
query predicate multipleLocations(Locatable e) { strictcount(e.getLocation()) > 1 }

/**
 * Holds if `e` does not have a `Location`.
 */
query predicate noLocation(Locatable e) { not exists(e.getLocation()) }

private predicate multiplePrimaryQlClasses(Element e) {
  strictcount(string cls | cls = e.getAPrimaryQlClass() and cls != "VariableAccess") > 1
}

/**
 * Holds if `e` has more than one `getPrimaryQlClasses()` result.
 */
query predicate multiplePrimaryQlClasses(Element e, string s) {
  multiplePrimaryQlClasses(e) and
  s = strictconcat(e.getPrimaryQlClasses(), ", ")
}

private Element getParent(Element child) { child = getChildAndAccessor(result, _, _) }

private predicate multipleParents(Element child) { strictcount(getParent(child)) > 1 }

/**
 * Holds if `child` has more than one AST parent.
 */
query predicate multipleParents(Element child, string childClass, Element parent, string parentClass) {
  multipleParents(child) and
  childClass = child.getPrimaryQlClasses() and
  parent = getParent(child) and
  parentClass = parent.getPrimaryQlClasses()
}

/** Holds if `parent` has multiple children at the same index. */
query predicate multipleChildren(Element parent, int index, Element child1, Element child2) {
  child1 = getChildAndAccessor(parent, index, _) and
  child2 = getChildAndAccessor(parent, index, _) and
  child1 != child2
}

/**
 * Holds if `child` has multiple positions amongst the `accessor` children
 * of `parent`.
 *
 * Children are allowed to have multiple positions for _different_ accessors,
 * for example in an array repeat expression `[1; 10]`, `1` has positions for
 * both `getRepeatOperand()` and `getExpr()`.
 */
query predicate multiplePositions(Element parent, int pos1, int pos2, string accessor, Element child) {
  child = getChildAndAccessor(parent, pos1, accessor) and
  child = getChildAndAccessor(parent, pos2, accessor) and
  pos1 != pos2
}

private import codeql.rust.elements.internal.PathResolution

/** Holds if `p` may resolve to multiple items including `i`. */
query predicate multiplePathResolutions(Path p, ItemNode i) {
  i = resolvePath(p) and
  strictcount(resolvePath(p)) > 1
}

/**
 * Gets counts of abstract syntax tree inconsistencies of each type.
 */
int getAstInconsistencyCounts(string type) {
  // total results from all the AST consistency query predicates.
  type = "Multiple toStrings" and
  result = count(Element e | multipleToStrings(e) | e)
  or
  type = "Multiple locations" and
  result = count(Element e | multipleLocations(e) | e)
  or
  type = "No location" and
  result = count(Element e | noLocation(e) | e)
  or
  type = "Multiple primary QL classes" and
  result = count(Element e | multiplePrimaryQlClasses(e) | e)
  or
  type = "Multiple parents" and
  result = count(Element e | multipleParents(e) | e)
  or
  type = "Multiple children" and
  result = count(Element e | multipleChildren(_, _, e, _) | e)
  or
  type = "Multiple positions" and
  result = count(Element e | multiplePositions(_, _, _, _, e) | e)
  or
  type = "Multiple path resolutions" and
  result = count(Path p | multiplePathResolutions(p, _) | p)
}
