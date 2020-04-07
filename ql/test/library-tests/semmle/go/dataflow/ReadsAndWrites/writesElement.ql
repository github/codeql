import go

from Write w, DataFlow::Node base, DataFlow::Node index, DataFlow::Node rhs
where w.writesElement(base, index, rhs)
select w, base, index, rhs
