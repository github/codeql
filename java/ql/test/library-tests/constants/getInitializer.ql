import semmle.code.java.Variable

from Variable v, Expr init, RefType enclosing
where
  v.getInitializer() = init and
  init.getEnclosingCallable().getDeclaringType() = enclosing and
  enclosing.hasQualifiedName("constants", "Initializers")
select v, init
