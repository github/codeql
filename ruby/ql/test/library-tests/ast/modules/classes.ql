import ruby

query predicate classes(ClassDeclaration c, string pClass, string name) {
  pClass = c.getAPrimaryQlClass() and name = c.getName()
}

query predicate classesWithNameScopeExprs(ClassDeclaration c, Expr se) { se = c.getScopeExpr() }

query predicate classesWithGlobalNameScopeExprs(ClassDeclaration c) { c.hasGlobalScope() }

query predicate exprsInClasses(ClassDeclaration c, int i, Expr e, string eClass) {
  e = c.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInClasses(ClassDeclaration c, Method m, string name) {
  m = c.getMethod(name)
}

query predicate classesInClasses(ClassDeclaration c, ClassDeclaration child, string name) {
  child = c.getClass(name)
}

query predicate modulesInClasses(ClassDeclaration c, ModuleDeclaration m, string name) {
  m = c.getModule(name)
}

query predicate classesWithASuperclass(ClassDeclaration c, Expr scExpr) {
  scExpr = c.getSuperclassExpr()
}
