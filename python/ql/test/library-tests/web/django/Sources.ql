
import python

import semmle.python.web.HttpRequest
import semmle.python.security.strings.Untrusted


from TaintSource src, TaintKind kind
where src.isSourceOf(kind)
select src.getLocation().toString(), src.(ControlFlowNode).getNode().toString(), kind
