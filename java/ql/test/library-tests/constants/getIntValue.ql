import semmle.code.java.Variable

from Variable v, CompileTimeConstantExpr init, RefType enclosing, QlBuiltins::BigInt constant
where
  v.getInitializer() = init and
  init.getEnclosingCallable().getDeclaringType() = enclosing and
  enclosing.hasQualifiedName("constants", "Values") and
  constant = init.getBigIntValue()
select init, constant.toString()
