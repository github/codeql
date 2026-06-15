import go

from Type t, string m, Type tp
where
  exists(t.getEntity().getDeclaration()) and
  t.hasMethod(m, tp)
select t, m, tp.pp()
