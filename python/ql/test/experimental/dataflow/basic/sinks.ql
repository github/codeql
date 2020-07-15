import allFlowsConfig

from DataFlow::Node sink
where exists(AllFlowsConfig cfg | cfg.isSink(sink))
select sink
