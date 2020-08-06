import experimental.dataflow.callGraphConfig

from DataFlow::Node source, DataFlow::Node sink
where
  source.getLocation().getFile().getBaseName() = "classes.py" and
  sink.getLocation().getFile().getBaseName() = "classes.py" and
  exists(CallGraphConfig cfg | cfg.hasFlow(source, sink))
select source, sink
// Rewrite this to just have 1-step paths?
