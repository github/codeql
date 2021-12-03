import allFlowsConfig

from DataFlow::Node source, DataFlow::Node sink
where
  source != sink and
  exists(AllFlowsConfig cfg | cfg.hasFlow(source, sink))
select source, sink
