import python
import semmle.python.TestUtils
import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted

from TaintedNode node
select remove_library_prefix(node.getLocation()), node.getAstNode().toString(), node.getTaintKind()
