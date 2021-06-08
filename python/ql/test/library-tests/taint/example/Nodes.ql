import python
import semmle.python.dataflow.TaintTracking
import semmle.python.dataflow.Implementation
import DilbertConfig

from TaintTrackingNode n
where n.getConfiguration() instanceof DilbertConfig
select n.getLocation().toString(), n.getNode().toString(), n.getPath().toString(),
  n.getContext().toString(), n.getTaintKind()
