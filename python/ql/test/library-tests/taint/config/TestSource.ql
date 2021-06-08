import python
import semmle.python.dataflow.TaintTracking
import TaintLib

from TestConfig config, DataFlow::Node source, TaintKind kind
where config.isSource(source, kind)
select config, source.getLocation().toString(), source.getLocation().getStartLine(),
  source.toString(), kind
