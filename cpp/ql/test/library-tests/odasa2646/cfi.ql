import cpp

from ConstructorFieldInit cfi, Expr e, string clazz
where
  e = cfi.getExpr() and
  clazz = e.getAQlClass() and
  clazz.endsWith("Literal")
select cfi, e, clazz
