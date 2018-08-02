import semmle.code.csharp.dataflow.flowsources.Remote

from RemoteFlowSource source
select source, source.getSourceType()
