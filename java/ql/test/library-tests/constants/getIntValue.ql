import semmle.code.java.Variable

from Variable v, CompileTimeConstantExpr init, RefType enclosing, int constant
where
  v.getInitializer() = init and
  init.getEnclosingCallable().getDeclaringType() = enclosing and
  enclosing.hasQualifiedName("constants", "Values") and
  constant = init.getIntValue()
select init, constant
