import experimental.dataflow.callGraphConfig

from DataFlow::Node source, DataFlow::Node sink
where exists(CallGraphConfig cfg | cfg.hasFlow(source, sink))
select source, sink
