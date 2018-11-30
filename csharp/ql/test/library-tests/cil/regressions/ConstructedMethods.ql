import cil::CIL

from UnboundGenericMethod f, ConstructedMethod fc
where
  fc.getUnboundMethod() = f and
  f.getQualifiedName() = "Methods.Class1.F"
select f, fc, fc.getTypeArgument(0)
