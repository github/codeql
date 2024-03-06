import csharp

deprecated query predicate labels(NamedElement ne, string label) {
  ne.getLabel() = label and ne.fromSource()
}
