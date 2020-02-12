import python
import semmle.python.security.injection.Sql
import semmle.python.web.django.Db
import semmle.python.web.django.Model
import semmle.python.security.strings.Untrusted

from SqlInjectionSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
