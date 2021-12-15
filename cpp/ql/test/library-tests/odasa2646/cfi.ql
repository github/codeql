import cpp

from ConstructorFieldInit cfi, Expr e, string clazz
where
  e = cfi.getExpr() and
  clazz = e.getAQlClass() and
  clazz.matches("%Literal")
select cfi, e, clazz
