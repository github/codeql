
import python


import semmle.python.web.django.Request
import semmle.python.web.django.Model
import semmle.python.web.django.Response
import semmle.python.security.strings.Untrusted


from TaintedNode node

select node.getLocation().toString(), node.getNode().getNode().toString(), node.getTaintKind().toString()

