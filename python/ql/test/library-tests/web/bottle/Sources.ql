
import python

import semmle.python.web.HttpRequest
import semmle.python.security.strings.Untrusted


from TaintSource src, TaintKind kind
where src.isSourceOf(kind) and not kind.matches("tornado%")
select src.getLocation().toString(), src.(ControlFlowNode).getNode().toString(), kind
