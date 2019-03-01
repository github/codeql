
import python


import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted


from TaintedNode node

select node.getLocation().toString(), node.getNode().getNode().toString(), node.getTaintKind()

