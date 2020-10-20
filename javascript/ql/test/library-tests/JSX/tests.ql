import javascript

query predicate htmlElements(JSXElement e) { e.getNameExpr() instanceof Label }

query predicate jsxElementAttribute(JSXElement elt, int i, JSXAttribute attr) {
  attr = elt.getAttribute(i)
}

query predicate jsxElementAttributeName(JSXElement elt, int i, string name) {
  name = elt.getAttribute(i).getName()
}

query predicate jsxElementBody(JSXElement elt, int i, Expr body) { elt.getBodyElement(i) = body }

query predicate jsxElementName(JSXElement elt, JSXName nameExpr, string name) {
  elt.getNameExpr() = nameExpr and
  name = elt.getName()
}

query predicate jsxFragments(JSXFragment fragment, int i, Expr body) {
  fragment.getBodyElement(i) = body
}
