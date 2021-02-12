import ruby

query predicate undef(UndefStmt u, int i, MethodName m, string pClass) {
  pClass = m.getAPrimaryQlClass() and
  u.getMethodName(i) = m
}

query predicate alias(AliasStmt a, string prop, MethodName m, string pClass) {
  pClass = m.getAPrimaryQlClass() and
  (
    a.getOldName() = m and prop = "old"
    or
    a.getNewName() = m and prop = "new"
  )
}
