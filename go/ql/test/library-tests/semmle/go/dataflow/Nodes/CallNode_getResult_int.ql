import go

from DataFlow::CallNode c, int i, DataFlow::Node outp
where outp = c.getResult(i)
select c, i, outp
