import javascript

query predicate htmlAttribute(HTML::Attribute a, HTML::Element e, string name, string val) {
  e = a.getElement() and
  name = a.getName() and
  val = a.getValue()
}

query predicate htmlElement_getAttribute(HTML::Element elt, int i, HTML::Attribute attr) {
  elt.getAttribute(i) = attr
}

query predicate htmlElement_getChild(HTML::Element elt, int i, HTML::Element child) {
  elt.getChild(i) = child
}

query predicate htmlElement_getName(HTML::Element elt, string name) { name = elt.getName() }

query predicate htmlElement_getParent(HTML::Element elt, HTML::Element parent) {
  parent = elt.getParent()
}
