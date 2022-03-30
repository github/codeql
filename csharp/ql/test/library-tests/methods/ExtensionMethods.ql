import csharp

from MethodCall mc, int i, Expr e
where
  mc.getTarget() instanceof ExtensionMethod and
  (
    e = mc.getArgument(i)
    or
    e = mc.getQualifier() and i = -1
  )
select mc, i, e
