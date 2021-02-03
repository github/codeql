import ruby

query predicate classes(Class c, string pClass, string name) {
  pClass = c.getAPrimaryQlClass() and name = c.getName()
}

query predicate classesWithScopeResolutionNames(Class c, ScopeResolution name) {
  name = c.getNameScopeResolution()
}

query predicate exprsInClasses(Class c, int i, Expr e, string eClass) {
  e = c.getExpr(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInClasses(Class c, Method m, string name) { m = c.getMethod(name) }

query predicate classesInClasses(Class c, Class child, string name) { child = c.getClass(name) }

query predicate modulesInClasses(Class c, Module m, string name) { m = c.getModule(name) }

query predicate classesWithASuperclass(Class c, Expr scExpr) { scExpr = c.getSuperclassExpr() }
