import java

from MethodAccess ma
select ma, ma.getAnArgument().getAChildExpr*().(StringLiteral), ma.getCallee(),
  ma.getCallee().getDeclaringType()
