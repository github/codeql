import python
import Taint

from Sanitizer s, TaintKind taint, PyEdgeRefinement test
where s.sanitizingEdge(taint, test)
select s, taint, test.getTest().getLocation().toString(), test.getRepresentation()
