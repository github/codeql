import allFlowsConfig

from DataFlow::Node sink
where
  exists(AllFlowsConfig cfg | cfg.isSink(sink)) and
  exists(sink.getLocation().getFile().getRelativePath())
select sink
