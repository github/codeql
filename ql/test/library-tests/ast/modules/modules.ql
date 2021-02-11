import ruby

query predicate modules(Module m, string pClass, string name) {
  pClass = m.getAPrimaryQlClass() and name = m.getName()
}

query predicate modulesWithScopeExprs(Module m, Expr se) { se = m.getScopeExpr() }

query predicate modulesWithGlobalNameScopeExprs(Module m) { m.hasGlobalScope() }

query predicate exprsInModules(Module m, int i, Expr e, string eClass) {
  e = m.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInModules(Module mod, Method method, string name) {
  method = mod.getMethod(name)
}

query predicate classesInModules(Module mod, Class klass, string name) {
  klass = mod.getClass(name)
}

query predicate modulesInModules(Module mod, Module child, string name) {
  child = mod.getModule(name)
}
