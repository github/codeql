import javascript

query predicate test_DoubleColonMethods(ExprStmt e, Identifier interface, Identifier id, Function f) {
  e.isDoubleColonMethod(interface, id, f)
}
