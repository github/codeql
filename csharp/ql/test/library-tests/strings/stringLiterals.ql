import csharp

query predicate stringLiterals(StringLiteral lit, string value) {
  lit.fromSource() and value = lit.getValue()
}
