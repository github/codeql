import go

from Entity e
where exists(e.getDeclaration())
select e, e.getType().pp()
