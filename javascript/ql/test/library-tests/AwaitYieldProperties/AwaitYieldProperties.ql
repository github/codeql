import javascript

query predicate errors(Error e, string msg) { msg = e.getMessage() }

query predicate propAccesses(PropAccess acc, string name) {
  name = acc.getPropertyName() and name = ["await", "yield"]
}

query predicate properties(Property p, string name) {
  name = p.getName() and name = ["await", "yield"]
}

query predicate methods(MethodDeclaration m, string name) {
  name = m.getName() and name = ["await", "yield"]
}
