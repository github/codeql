
import python


import semmle.python.web.django.Request
import semmle.python.web.django.Model
import semmle.python.web.django.Response
import semmle.python.security.strings.Untrusted

from TaintSource src, TaintKind kind
where src.isSourceOf(kind)
select src.getLocation().toString(), src.(ControlFlowNode).getNode().toString(), kind.toString()
