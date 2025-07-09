import javascript

query TypeAnnotation hasUnderlyingTypeModule(string moduleName, string member) {
  result.hasUnderlyingType(moduleName, member)
}

query TypeAnnotation hasUnderlyingTypeGlobal(string globalName) {
  result.hasUnderlyingType(globalName)
}

query Parameter paramExample() {
  result.getTypeAnnotation().hasUnderlyingType("named-import", "Name1")
}
