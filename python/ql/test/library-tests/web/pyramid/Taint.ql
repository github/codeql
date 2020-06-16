import python
import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted

from TaintedNode node
where node.getLocation().getFile().getShortName() = "test.py"
select node.getLocation().toString(), node.getAstNode().toString(), node.getTaintKind()
