import csharp

query predicate arguments(Attribute attribute, int index, Expr e) {
  e.fromSource() and
  e = attribute.getArgument(index)
}

query predicate constructorArguments(Attribute attribute, int index, Expr e) {
  e.fromSource() and
  e = attribute.getConstructorArgument(index)
}

query predicate namedArguments(Attribute attribute, string name, Expr e) {
  e.fromSource() and
  e = attribute.getNamedArgument(name)
}
