import rust
import codeql.rust.elements.internal.generated.ParentChild

query predicate multipleToString(Element e, string s) {
  s = strictconcat(e.toString(), ",") and
  strictcount(e.toString()) > 1
}

query predicate multipleLocations(Locatable e) { strictcount(e.getLocation()) > 1 }

query predicate multiplePrimaryQlClasses(Element e, string s) {
  s = e.getPrimaryQlClasses() and
  strictcount(e.getAPrimaryQlClass()) > 1
}

private Element getParent(Element child) { child = getChildAndAccessor(result, _, _) }

query predicate multipleParents(Element child, Element parent) {
  parent = getParent(child) and
  strictcount(getParent(child)) > 1
}
