import ruby

private string getValueText(MethodName m) {
  result = m.getConstantValue().getStringlikeValue()
  or
  not exists(m.getConstantValue()) and result = "(none)"
}

query predicate undef(UndefStmt u, int i, MethodName m, string name, string pClass) {
  pClass = m.getAPrimaryQlClass() and
  u.getMethodName(i) = m and
  name = getValueText(m)
}

query predicate alias(AliasStmt a, string prop, MethodName m, string name, string pClass) {
  pClass = m.getAPrimaryQlClass() and
  name = getValueText(m) and
  (
    a.getOldName() = m and prop = "old"
    or
    a.getNewName() = m and prop = "new"
  )
}
