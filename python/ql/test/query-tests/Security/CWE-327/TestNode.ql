import python
import semmle.python.security.TaintTracking
import python
import semmle.python.security.SensitiveData
import semmle.python.security.Crypto

from TaintedNode n, AstNode src
where src = n.getAstNode() and src.getLocation().getFile().getAbsolutePath().matches("%test%")
select "Taint " + n.getTaintKind(), n.getLocation(), src, n.getContext()
