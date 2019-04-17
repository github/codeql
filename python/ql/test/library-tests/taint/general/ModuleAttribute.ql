import python
import semmle.python.security.TaintTest
import TaintLib


from ModuleValue m, string name, TaintedNode origin

where TaintFlowTest::module_attribute_tainted(m, name, origin)

select m.toString(), name, origin.getTrackedValue(), origin.getContext(), origin.getLocation().toString()
