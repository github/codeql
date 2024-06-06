import allFlowsConfig

from DataFlow::Node source
where
  AllFlowsConfig::isSource(source) and
  exists(source.getLocation().getFile().getRelativePath())
select source
