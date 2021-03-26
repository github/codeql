import ruby

query predicate classes(ClassDefinition c, string pClass, string name) {
  pClass = c.getAPrimaryQlClass() and name = c.getName()
}

query predicate classesWithNameScopeExprs(ClassDefinition c, Expr se) { se = c.getScopeExpr() }

query predicate classesWithGlobalNameScopeExprs(ClassDefinition c) { c.hasGlobalScope() }

query predicate exprsInClasses(ClassDefinition c, int i, Expr e, string eClass) {
  e = c.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInClasses(ClassDefinition c, Method m, string name) { m = c.getMethod(name) }

query predicate classesInClasses(ClassDefinition c, ClassDefinition child, string name) {
  child = c.getClass(name)
}

query predicate modulesInClasses(ClassDefinition c, ModuleDefinition m, string name) {
  m = c.getModule(name)
}

query predicate classesWithASuperclass(ClassDefinition c, Expr scExpr) {
  scExpr = c.getSuperclassExpr()
}
