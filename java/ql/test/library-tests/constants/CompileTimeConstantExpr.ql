import semmle.code.java.Expr

from CompileTimeConstantExpr constant, RefType tpe
where
  constant.getEnclosingCallable().getDeclaringType() = tpe and
  tpe.hasQualifiedName("constants", "Constants")
select constant
