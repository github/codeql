import javascript

query predicate globalQualifiedNames(TypeReference type, string globalName) {
  type.hasQualifiedName(globalName) and
  not type.hasTypeArguments()
}

query predicate moduleQualifiedName(TypeReference type, string moduleName, string exportedName) {
  type.hasQualifiedName(moduleName, exportedName) and
  not type.hasTypeArguments()
}

string getDefinition(TypeReference ref) {
  if exists(ref.getADefinition())
  then result = "defined in " + ref.getADefinition().getFile().getBaseName()
  else result = "has no definition"
}

query predicate types(TypeReference type, string def) {
  not type.hasTypeArguments() and
  def = getDefinition(type)
}

query predicate uniqueSymbols(UniqueSymbolType symbol, string moduleName, string exportedName) {
  symbol.hasQualifiedName(moduleName, exportedName)
}
