import csharp

from ConstructedMethod cm
where
  cm.hasName("CM3") and
  cm.getParameter(0).getType() instanceof DoubleType and
  cm.getParameter(1).getType() instanceof IntType and
  cm.getReturnType() instanceof DoubleType and
  exists(Method sourceDeclaration |
    sourceDeclaration = cm.getSourceDeclaration() and
    sourceDeclaration.getParameter(0).getType().(TypeParameter).hasName("T2") and
    sourceDeclaration.getParameter(1).getType().(TypeParameter).hasName("T1") and
    sourceDeclaration.getReturnType().(TypeParameter).hasName("T2")
  ) and
  exists(Method unbound |
    unbound = cm.getUnboundGeneric() and
    unbound.getParameter(0).getType().(TypeParameter).hasName("T2") and
    unbound.getParameter(1).getType() instanceof IntType and
    unbound.getReturnType().(TypeParameter).hasName("T2")
  )
select cm
