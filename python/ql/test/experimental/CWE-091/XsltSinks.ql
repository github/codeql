import python
import experimental.semmle.python.security.injection.XSLT

from XSLTInjection::XSLTInjectionSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
