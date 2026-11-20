import semmle.code.csharp.security.dataflow.flowsources.Remote

from RemoteFlowSource source
where
  source.getLocation().getFile().fromSource() and
  not source.getLocation().getFile().getAbsolutePath().contains("/resources/stubs/")
select source, source.getSourceType()
