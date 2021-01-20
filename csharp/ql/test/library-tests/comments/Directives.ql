import csharp

query predicate directives(PreprocessorDirective d, Location l, string isActive) {
  d.getALocation() = l and
  if d.active() then isActive = "active" else isActive = "inactive"
}
