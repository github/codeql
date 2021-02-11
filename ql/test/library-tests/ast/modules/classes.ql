import ruby

query predicate classes(Class c, string pClass, string name) {
  pClass = c.getAPrimaryQlClass() and name = c.getName()
}

query predicate classesWithNameScopeExprs(Class c, Expr se) { se = c.getScopeExpr() }

query predicate classesWithGlobalNameScopeExprs(Class c) { c.hasGlobalScope() }

query predicate exprsInClasses(Class c, int i, Expr e, string eClass) {
  e = c.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInClasses(Class c, Method m, string name) { m = c.getMethod(name) }

query predicate classesInClasses(Class c, Class child, string name) { child = c.getClass(name) }

query predicate modulesInClasses(Class c, Module m, string name) { m = c.getModule(name) }

query predicate classesWithASuperclass(Class c, Expr scExpr) { scExpr = c.getSuperclassExpr() }
