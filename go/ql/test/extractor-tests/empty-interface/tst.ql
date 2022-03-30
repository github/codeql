import go

where exists(InterfaceType empty | not empty.hasMethod(_, _))
select "success"
