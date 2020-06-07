import python
import experimental.semmle.python.security.injection.Xpath

from XpathInjection::XpathInjectionSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind