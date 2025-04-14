import go

from DefinedType t, string m, Type tp
where
  exists(t.getEntity().getDeclaration()) and
  t.getBaseType().hasMethod(m, tp)
select t, m, tp.pp()
