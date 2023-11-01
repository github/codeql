import allFlowsConfig

from DataFlow::Node source, DataFlow::Node sink
where
  source != sink and
  exists(AllFlowsConfig cfg | cfg.hasFlow(source, sink)) and
  exists(source.getLocation().getFile().getRelativePath()) and
  exists(sink.getLocation().getFile().getRelativePath())
select source, sink
