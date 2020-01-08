import python
import semmle.python.web.HttpResponse
import semmle.python.security.strings.Untrusted

// from HttpResponseTaintSink sink, TaintKind kind
// where sink.sinks(kind)
// select sink, kind
select "FIXME: temporarily disabled since it's not working"
