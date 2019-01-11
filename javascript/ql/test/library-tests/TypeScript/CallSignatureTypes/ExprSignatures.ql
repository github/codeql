import javascript

string getASignatureOrElseType(Type t) {
  result = t.getASignature(_).toString()
  or
  not exists(t.getASignature(_)) and
  result = t.toString()
}

from Expr expr
where
  not exists(MethodDeclaration decl | decl.getNameExpr() = expr) and
  not exists(DotExpr dot | expr = dot.getPropertyNameExpr())
select expr, getASignatureOrElseType(expr.getType())
