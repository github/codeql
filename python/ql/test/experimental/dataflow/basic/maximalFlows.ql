import maximalFlowsConfig

from DataFlow::Node source, DataFlow::Node sink
where
  source != sink and
  exists(MaximalFlowsConfig cfg | cfg.hasFlow(source, sink))
select source, sink
