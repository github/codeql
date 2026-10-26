import utils.test.dataflow.callGraphConfig

from DataFlow::Node source, DataFlow::Node sink
where
  CallGraphFlow::flow(source, sink) and
  exists(source.getLocation().getFile().getRelativePath()) and
  exists(sink.getLocation().getFile().getRelativePath())
select source, sink
