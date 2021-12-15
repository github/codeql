import allFlowsConfig

from DataFlow::Node source
where exists(AllFlowsConfig cfg | cfg.isSource(source))
select source
