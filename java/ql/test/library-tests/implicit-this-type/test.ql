import java

from MethodCall ma
select ma, ma.getAnArgument().getAChildExpr*().(StringLiteral), ma.getCallee(),
  ma.getCallee().getDeclaringType()
