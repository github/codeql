import allFlowsConfig

from DataFlow::Node sink
where
  AllFlowsConfig::isSink(sink) and
  exists(sink.getLocation().getFile().getRelativePath())
select sink
