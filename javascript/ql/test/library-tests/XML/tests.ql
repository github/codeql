import javascript

query predicate xmlAttribute(XMLAttribute attr, XMLElement element, string name, string value) {
  attr.getElement() = element and
  attr.getName() = name and
  attr.getValue() = value
}

query predicate xmlComment(XMLComment c, string text) { text = c.getText() }

query predicate xmlElement_getAnAttribute(XMLElement e, XMLAttribute attr) {
  attr = e.getAnAttribute()
}

query predicate xmlElement(XMLElement elt, string name, XMLParent parent, int index, XMLFile file) {
  name = elt.getName() and
  parent = elt.getParent() and
  index = elt.getIndex() and
  file = elt.getFile()
}

query predicate xmlFile(XMLFile f) { any() }

query predicate xmlLocatable(XMLLocatable x) { any() }

query predicate xmlParent_getChild(XMLParent p, int i, XMLElement child) { child = p.getChild(i) }

query predicate xmlParent_getTextValue(XMLParent p, string text) { p.getTextValue() = text }
