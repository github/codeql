import experimental.dataflow.callGraphConfig

from DataFlow::Node source
where
  exists(CallGraphConfig cfg | cfg.isSource(source)) and
  exists(source.getLocation().getFile().getRelativePath())
select source
