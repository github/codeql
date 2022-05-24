import go

from FunctionOutput outp, int i, DataFlow::CallNode c, DataFlow::Node nodeTo
where outp.isResult(i) and nodeTo = outp.getNode(c)
select c, nodeTo, i, outp
