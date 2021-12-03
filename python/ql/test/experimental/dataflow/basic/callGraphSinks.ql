import experimental.dataflow.callGraphConfig

from DataFlow::Node sink
where exists(CallGraphConfig cfg | cfg.isSink(sink))
select sink
