import cpp

Declaration initializedDecl(Expr e) {
  exists(Initializer i | i.getExpr() = e and i.getDeclaration() = result)
}

from Expr e, string enclosedBy, string initializes
where
  (
    if exists(e.getEnclosingFunction())
    then enclosedBy = e.getEnclosingFunction().toString()
    else enclosedBy = ""
  ) and
  if exists(initializedDecl(e))
  then initializes = initializedDecl(e).toString()
  else initializes = ""
select e, initializes, enclosedBy
