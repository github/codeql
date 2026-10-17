import python
import semmle.python.dataflow.new.RemoteFlowSources

from RemoteFlowSource src
where exists(src.getLocation().getFile().getRelativePath())
select src, src.getSourceType()
