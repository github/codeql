import python
import semmle.python.security.TaintTracking
import Taint


from TaintedNode n, TaintedNode s
where n.getLocation().getFile().getName().matches("%test.py") and
s.getLocation().getFile().getName().matches("%test.py") and
s = n.getASuccessor()
select 
    "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getAstNode(), n.getContext(),
    " --> ",
    "Taint " + s.getTaintKind(), s.getLocation().toString(), s.getAstNode(), s.getContext()
