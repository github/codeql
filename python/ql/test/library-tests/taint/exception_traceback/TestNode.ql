import python
import semmle.python.security.Exceptions
import semmle.python.web.HttpResponse

from TaintedNode node
where not node.getLocation().getFile().inStdlib()
select node.getLocation(), node.getNode().asAstNode().toString(), node.getTaintKind()
