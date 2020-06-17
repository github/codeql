import allFlowsConfig

from
  DataFlow::Node source,
  DataFlow::Node sink
where
  exists(AllFlowsConfig cfg | cfg.hasFlow(source, sink))
select
  source, sink
