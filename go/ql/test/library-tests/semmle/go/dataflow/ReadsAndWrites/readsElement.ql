import go

from DataFlow::ReadNode r, DataFlow::Node base, DataFlow::Node index
where r.readsElement(base, index)
select r, base, index
