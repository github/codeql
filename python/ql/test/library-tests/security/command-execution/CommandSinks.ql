import python
import semmle.python.security.injection.Command

from CommandSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
