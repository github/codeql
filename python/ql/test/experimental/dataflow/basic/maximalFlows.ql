import maximalFlowsConfig

from DataFlow::Node source, DataFlow::Node sink
where
  source != sink and
  exists(MaximalFlowsConfig cfg | cfg.hasFlow(source, sink)) and
  exists(source.getLocation().getFile().getRelativePath()) and
  exists(sink.getLocation().getFile().getRelativePath())
select source, sink
