import go

from DataFlow::ReadNode r, DataFlow::Node base, Method m
where r.readsMethod(base, m)
select r, base, m
