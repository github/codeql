import swift

query predicate noStaticTarget(CallExpr c, Expr func, string funcClass) {
  not exists(c.getStaticTarget()) and
  func = c.getFunction() and
  funcClass = func.getPrimaryQlClasses()
}

from CallExpr c, boolean hasStaticTarget
where
  if exists(c.getStaticTarget().toString())
  then
    hasStaticTarget = true and
    not c.getStaticTarget().toString() = "zeroInitializer()" // Omit because a different number of these calls appear in linux and macos
  else hasStaticTarget = false
select c, hasStaticTarget
