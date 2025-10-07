import utils.test.dataflow.callGraphConfig

from DataFlow::Node source
where
  CallGraphConfig::isSource(source) and
  exists(source.getLocation().getFile().getRelativePath())
select source
