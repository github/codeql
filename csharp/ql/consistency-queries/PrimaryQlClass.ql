import csharp

query predicate missingPrimaryQlClass(Element e) {
  e.getAPrimaryQlClass() = "???" and
  e.fromSource()
}
