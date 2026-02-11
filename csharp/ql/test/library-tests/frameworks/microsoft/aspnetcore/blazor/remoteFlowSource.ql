import semmle.code.csharp.security.dataflow.flowsources.Remote

from RemoteFlowSource source, File f
where
  source.getLocation().getFile() = f and
  f.fromSource()
select source, source.getSourceType()
