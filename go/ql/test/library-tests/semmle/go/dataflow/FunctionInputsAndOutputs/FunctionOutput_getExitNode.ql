import go

from FunctionOutput outp, DataFlow::CallNode c
select outp, c, outp.getExitNode(c)
