import ruby

query predicate singletonClasses(SingletonClass sc, string pClass, Expr value) {
  pClass = sc.getAPrimaryQlClass() and value = sc.getValue()
}

query predicate exprsInSingletonClasses(SingletonClass sc, int i, Expr e, string eClass) {
  e = sc.getStmt(i) and eClass = e.getAPrimaryQlClass()
}

query predicate methodsInSingletonClasses(SingletonClass sc, Method m) { m = sc.getAMethod() }
