import csharp

query predicate attributable(Attributable element, Attribute attribute, string name) {
  attribute = element.getAnAttribute() and
  name = attribute.getType().getQualifiedName()
}

query predicate assembly(Assembly a, Attribute attribute, string name) {
  attribute = a.getAnAttribute() and
  name = attribute.getType().getQualifiedName()
}
