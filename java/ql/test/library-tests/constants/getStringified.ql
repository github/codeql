import java

from Variable v, CompileTimeConstantExpr init, RefType enclosing, string constant
where
  v.getInitializer() = init and
  init.getEnclosingCallable().getDeclaringType() = enclosing and
  enclosing.hasQualifiedName("constants", ["Values", "Stringified"]) and
  constant = init.getStringifiedValue()
select init, constant
