import csharp

query predicate noBody(LocalFunction lf) { not lf.hasBody() }

query predicate localFunctionModifier(LocalFunction lf, string modifier) {
  lf.hasModifier(modifier)
}

query predicate localFunctionAttribute(LocalFunction lf, Attribute a) { a = lf.getAnAttribute() }
