import swift

query predicate noStaticTarget(CallExpr c, Expr func, string funcClass) {
  not exists(c.getStaticTarget()) and
  func = c.getFunction() and
  funcClass = func.getPrimaryQlClasses()
}

from CallExpr c, boolean hasStaticTarget, string staticTarget
where
  if exists(c.getStaticTarget().toString())
  then (
    hasStaticTarget = true and
    staticTarget = c.getStaticTarget().toString()
  ) else (
    hasStaticTarget = false and
    staticTarget = "-"
  )
select c, hasStaticTarget, staticTarget
