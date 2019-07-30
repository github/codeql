import python
import semmle.python.security.TaintTracking
import TaintLib

from TaintTracking::Configuration config, DataFlow::Node source, TaintKind kind

where config.isSource(source, kind)
select config, source.getLocation().toString(), source.getLocation().getStartLine(), source.toString(), kind
