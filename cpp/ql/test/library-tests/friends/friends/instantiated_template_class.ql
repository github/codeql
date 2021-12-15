import cpp

from Class c
where c.getName().matches("SelfFriendlyTemplate<__%>")
select c.toString() as parent, c.getAFriendDecl().getFriend().toString() as friend order by
    parent, friend
