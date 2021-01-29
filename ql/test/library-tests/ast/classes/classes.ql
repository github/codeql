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

query predicate methodsInClasses(Class c, Method m) { m = c.getAMethod() }

query predicate classesWithASuperclass(Class c, Expr scExpr) { scExpr = c.getSuperclassExpr() }
