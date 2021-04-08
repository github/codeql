import experimental.dataflow.callGraphConfig

from DataFlow::Node source, DataFlow::Node sink
where
  source.getLocation().getFile().getBaseName() = "classes.py" and
  sink.getLocation().getFile().getBaseName() = "classes.py" and
  exists(CallGraphConfig cfg | cfg.hasFlow(source, sink))
select source, sink
// Ideally, we would just have 1-step paths either from argument to parameter
// or from return to call. This gives a bit more, so should be rewritten.
