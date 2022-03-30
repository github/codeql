import csharp

query predicate missingPrimaryQlClass(Element e) {
  not exists(e.getAPrimaryQlClass()) and
  e.fromSource()
}
