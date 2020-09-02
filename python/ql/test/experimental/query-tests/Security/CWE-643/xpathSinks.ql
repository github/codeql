import python
import experimental.semmle.python.security.injection.Xpath
import semmle.python.security.strings.Untrusted

from XpathInjection::XpathInjectionSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
