import go

from Write w, DataFlow::Node base, Field f, DataFlow::Node rhs
where w.writesField(base, f, rhs)
select w, base, f, rhs
