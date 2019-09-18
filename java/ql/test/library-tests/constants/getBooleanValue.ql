import semmle.code.java.Variable

from Variable v, Expr init, RefType enclosing, boolean constant
where
  v.getInitializer() = init and
  init.getEnclosingCallable().getDeclaringType() = enclosing and
  enclosing.hasQualifiedName("constants", "Values") and
  constant = init.(CompileTimeConstantExpr).getBooleanValue()
select init, constant
