import javascript

query predicate test_Module_exports(Module m, string name, ASTNode export) {
  m.exports(name, export)
}
