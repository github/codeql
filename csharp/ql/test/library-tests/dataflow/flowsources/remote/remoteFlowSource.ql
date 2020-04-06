import semmle.code.csharp.security.dataflow.flowsources.Remote

from RemoteFlowSource source
select source, source.getSourceType()
