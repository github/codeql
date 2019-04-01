import csharp

query predicate arguments(Attribute attribute, int index, Expr e) {
  e = attribute.getArgument(index)
}

query predicate constructorArguments(Attribute attribute, int index, Expr e) {
  e = attribute.getConstructorArgument(index)
}

query predicate namedArguments(Attribute attribute, string name, Expr e) {
  e = attribute.getNamedArgument(name)
}
