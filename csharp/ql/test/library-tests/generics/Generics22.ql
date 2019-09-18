import csharp

from ConstructedMethod m, ValueOrRefType tp
where
  m.getName().matches("CM%") and
  tp = m.getATypeArgument()
select m, tp.getName()
