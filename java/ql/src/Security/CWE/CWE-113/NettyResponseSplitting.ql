import java

from ClassInstanceExpr new
where
  new.getConstructedType().hasQualifiedName("io.netty.handler.codec.http", "DefaultHttpHeaders") and
  new.getArgument(0).getProperExpr().(BooleanLiteral).getBooleanValue() = false
select new, "Response-splitting vulnerability due to verification being disabled."
