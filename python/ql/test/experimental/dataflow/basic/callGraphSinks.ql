import experimental.dataflow.callGraphConfig

from DataFlow::Node sink
where
  exists(CallGraphConfig cfg | cfg.isSink(sink)) and
  exists(sink.getLocation().getFile().getRelativePath())
select sink
