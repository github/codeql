import go

from FunctionOutput outp, DataFlow::CallNode c, DataFlow::Node nodeTo
where outp.isResult() and nodeTo = outp.getNode(c)
select c, nodeTo, outp
