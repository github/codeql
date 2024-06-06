import semmle.code.csharp.security.dataflow.flowsources.Remote

from RemoteFlowSource source
where source.getLocation().getFile().fromSource()
select source, source.getSourceType()
