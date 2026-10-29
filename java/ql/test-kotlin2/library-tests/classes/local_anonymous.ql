import java

private predicate filterFile(Top t) { t.getFile().getRelativePath().matches("%local_anonymous.kt") }

private string isAnonymousType(Type t) {
  if t instanceof AnonymousClass then result = "anonymous" else result = "not anonymous"
}

private string isLocalType(Type t) {
  if t instanceof LocalClassOrInterface then result = "local" else result = "not local"
}

query predicate anonymousObjects(ClassInstanceExpr e, Type t, string anon, string local) {
  filterFile(e) and
  exists(AnonymousClass c | e = c.getClassInstanceExpr()) and
  not exists(LambdaExpr l | l.getType() = t) and
  not exists(MemberRefExpr mr | mr.getType() = t) and
  not exists(Method m | m = t.(Class).getAMethod() and m.isLocal()) and
  t = e.getType() and
  anon = isAnonymousType(t) and
  local = isLocalType(t)
}

query predicate localFunctions(Method m, Type t, string anon, string local) {
  filterFile(m) and
  m.isLocal() and
  t = m.getDeclaringType() and
  anon = isAnonymousType(t) and
  local = isLocalType(t)
}

query predicate lambdas(LambdaExpr e, Type t, string anon, string local) {
  filterFile(e) and
  t = e.getType() and
  anon = isAnonymousType(t) and
  local = isLocalType(t)
}

query predicate memberRefs(MemberRefExpr e, Type t, string anon, string local) {
  filterFile(e) and
  t = e.getType() and
  anon = isAnonymousType(t) and
  local = isLocalType(t)
}

query predicate localClasses(LocalClass c, string anon, string local) {
  filterFile(c) and
  not c instanceof AnonymousClass and
  anon = isAnonymousType(c) and
  local = isLocalType(c)
}
