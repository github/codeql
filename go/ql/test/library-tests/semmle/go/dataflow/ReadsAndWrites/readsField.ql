import go

from DataFlow::ReadNode r, DataFlow::Node base, Field f
where r.readsField(base, f)
select r, base, f
