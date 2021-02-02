import ruby

query predicate modules(Module m, string pClass, string name) {
  pClass = m.getAPrimaryQlClass() and name = m.getName()
}

query predicate modulesWithScopeResolutionNames(Module m, ScopeResolution name) {
  name = m.getNameScopeResolution()
}

query predicate exprsInModules(Module m, int i, Expr e, string eClass) {
  e = m.getExpr(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInModules(Module mod, Method method) { method = mod.getAMethod() }
