import python
import semmle.python.security.injection.Sql
import semmle.python.web.django.Db
import semmle.python.web.django.Model

from SqlInjectionSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
