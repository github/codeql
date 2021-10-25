import python
import semmle.python.security.injection.Command
import semmle.python.security.strings.Untrusted

from CommandSink sink, TaintKind kind
where sink.sinks(kind)
select sink, kind
