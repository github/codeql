import javascript

query predicate xmlAttribute(XmlAttribute attr, XmlElement element, string name, string value) {
  attr.getElement() = element and
  attr.getName() = name and
  attr.getValue() = value
}

query predicate xmlComment(XmlComment c, string text) { text = c.getText() }

query predicate xmlElement_getAnAttribute(XmlElement e, XmlAttribute attr) {
  attr = e.getAnAttribute()
}

query predicate xmlElement(XmlElement elt, string name, XmlParent parent, int index, XmlFile file) {
  name = elt.getName() and
  parent = elt.getParent() and
  index = elt.getIndex() and
  file = elt.getFile()
}

query predicate xmlFile(XmlFile f) { any() }

query predicate xmlLocatable(XmlLocatable x) { any() }

query predicate xmlParent_getChild(XmlParent p, int i, XmlElement child) { child = p.getChild(i) }

query predicate xmlParent_getTextValue(XmlParent p, string text) { p.getTextValue() = text }
