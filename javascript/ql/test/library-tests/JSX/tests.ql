import javascript

query predicate htmlElements(JsxElement e) { e.getNameExpr() instanceof Label }

query predicate jsxElementAttribute(JsxElement elt, int i, JsxAttribute attr) {
  attr = elt.getAttribute(i)
}

query predicate jsxElementAttributeName(JsxElement elt, int i, string name) {
  name = elt.getAttribute(i).getName()
}

query predicate jsxElementBody(JsxElement elt, int i, Expr body) { elt.getBodyElement(i) = body }

query predicate jsxElementName(JsxElement elt, JsxName nameExpr, string name) {
  elt.getNameExpr() = nameExpr and
  name = elt.getName()
}

query predicate jsxFragments(JsxFragment fragment, int i, Expr body) {
  fragment.getBodyElement(i) = body
}
