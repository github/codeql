import go

from DataFlow::Node pred, DataFlow::Node succ
where
  exists(FunctionInput inp, FunctionOutput outp, DataFlow::CallNode call |
    exists(TaintTracking::FunctionModel f | call.getTarget() = f | f.hasTaintFlow(inp, outp))
    or
    exists(DataFlow::FunctionModel f | call.getTarget() = f | f.hasDataFlow(inp, outp))
  |
    pred = inp.getEntryNode(call) and succ = outp.getExitNode(call)
  )
select pred, succ
