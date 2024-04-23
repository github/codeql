import experimental.dataflow.callGraphConfig

from DataFlow::Node sink
where
  CallGraphConfig::isSink(sink) and
  exists(sink.getLocation().getFile().getRelativePath())
select sink
