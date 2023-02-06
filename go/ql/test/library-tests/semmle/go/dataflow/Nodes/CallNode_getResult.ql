import go

from DataFlow::CallNode c, DataFlow::Node outp
where outp = c.getResult()
select c, outp
