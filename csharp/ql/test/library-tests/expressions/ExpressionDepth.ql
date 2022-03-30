import csharp

from Field f
where f.getDeclaringType().hasName("ExpressionDepth")
select count(Literal l | l = f.getAChild+()), f.getInitializer().getValue()
