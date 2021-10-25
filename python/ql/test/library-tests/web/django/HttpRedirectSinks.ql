import python
import semmle.python.web.HttpRedirect
import semmle.python.security.strings.Untrusted

from HttpRedirectTaintSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
