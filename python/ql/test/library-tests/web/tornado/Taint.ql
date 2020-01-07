import python
import semmle.python.TestUtils
import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted

from TaintedNode node
// Add this restriction to keep Python2 and 3 results the same.
where not exists(node.getContext().getCaller())
select remove_library_prefix(node.getLocation()), node.getAstNode().toString(), node.getTaintKind()
