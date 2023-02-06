import go

from Type t
where exists(t.getEntity().getDeclaration())
select t, t.getQualifiedName()
