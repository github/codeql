import python
import experimental.semmle.python.security.injection.XSLT

from XsltInjection::XsltInjectionSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
