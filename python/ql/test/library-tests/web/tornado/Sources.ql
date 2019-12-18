
import python

import semmle.python.TestUtils

import semmle.python.web.HttpRequest
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted


from TaintSource src, TaintKind kind
where src.isSourceOf(kind)
select remove_library_prefix(src.getLocation()), src.(ControlFlowNode).getNode().toString(), kind
