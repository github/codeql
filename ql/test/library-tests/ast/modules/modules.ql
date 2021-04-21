import ruby

query predicate modules(ModuleDeclaration m, string pClass, string name) {
  pClass = m.getAPrimaryQlClass() and name = m.getName()
}

query predicate modulesWithScopeExprs(ModuleDeclaration m, Expr se) { se = m.getScopeExpr() }

query predicate modulesWithGlobalNameScopeExprs(ModuleDeclaration m) { m.hasGlobalScope() }

query predicate exprsInModules(ModuleDeclaration m, int i, Expr e, string eClass) {
  e = m.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInModules(ModuleDeclaration mod, Method method, string name) {
  method = mod.getMethod(name)
}

query predicate classesInModules(ModuleDeclaration mod, ClassDeclaration klass, string name) {
  klass = mod.getClass(name)
}

query predicate modulesInModules(ModuleDeclaration mod, ModuleDeclaration child, string name) {
  child = mod.getModule(name)
}
