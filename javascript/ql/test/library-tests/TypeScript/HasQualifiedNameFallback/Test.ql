import javascript

query TypeAnnotation hasQualifiedNameModule(string moduleName, string member) {
  result.hasQualifiedName(moduleName, member)
}

query TypeAnnotation hasQualifiedNameGlobal(string globalName) {
  result.hasQualifiedName(globalName)
}

query Parameter paramExample() {
  result.getTypeAnnotation().hasQualifiedName("named-import", "Name1")
}
