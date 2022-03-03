import semmle.code.java.Variable

from Variable v, Expr init, RefType enclosing, string constant
where
  v.getInitializer() = init and
  init.getEnclosingCallable().getDeclaringType() = enclosing and
  enclosing.hasQualifiedName("constants", "Values") and
  constant = init.(CompileTimeConstantExpr).getStringValue()
select init, constant
