import python
import semmle.python.dataflow.TaintTracking
import TaintLib

from Sanitizer s, TaintKind taint, PyEdgeRefinement test
where s.sanitizingEdge(taint, test)
select s, taint, test.getLocation().toString(), test.getRepresentation()
