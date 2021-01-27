import csharp
private import semmle.code.csharp.commons.Compilation

query predicate directives(PreprocessorDirective d, Location l, string isActive) {
  d.getALocation() = l and
  if d.isActive() then isActive = "active" else isActive = "inactive"
}

query predicate comp(PreprocessorDirective d, Compilation c) { d.getCompilation() = c }
