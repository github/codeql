import experimental.dataflow.callGraphConfig

from DataFlow::Node source
where exists(CallGraphConfig cfg | cfg.isSource(source))
select source
