import cpp

from VariableDeclarationEntry vd, Type t
where t = vd.getType()
select vd, t.explain(), count(Type u | u = vd.getType())
