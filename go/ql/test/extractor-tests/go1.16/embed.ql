import go

from Variable v
where exists(v.getDeclaration())
select v
