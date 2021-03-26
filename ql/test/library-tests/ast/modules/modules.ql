import ruby

query predicate modules(ModuleDefinition m, string pClass, string name) {
  pClass = m.getAPrimaryQlClass() and name = m.getName()
}

query predicate modulesWithScopeExprs(ModuleDefinition m, Expr se) { se = m.getScopeExpr() }

query predicate modulesWithGlobalNameScopeExprs(ModuleDefinition m) { m.hasGlobalScope() }

query predicate exprsInModules(ModuleDefinition m, int i, Expr e, string eClass) {
  e = m.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInModules(ModuleDefinition mod, Method method, string name) {
  method = mod.getMethod(name)
}

query predicate classesInModules(ModuleDefinition mod, ClassDefinition klass, string name) {
  klass = mod.getClass(name)
}

query predicate modulesInModules(ModuleDefinition mod, ModuleDefinition child, string name) {
  child = mod.getModule(name)
}
