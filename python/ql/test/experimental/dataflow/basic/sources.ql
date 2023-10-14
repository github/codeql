import allFlowsConfig

from DataFlow::Node source
where
  exists(AllFlowsConfig cfg | cfg.isSource(source)) and
  exists(source.getLocation().getFile().getRelativePath())
select source
