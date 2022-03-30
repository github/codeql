import python
import semmle.python.dataflow.Implementation
import TaintLib

from ModuleValue m, string name, TaintedNode origin, TaintTrackingImplementation impl
where impl.moduleAttributeTainted(m, name, origin)
select m.toString(), name, origin.toString(), origin.getContext(), origin.getLocation().toString()
