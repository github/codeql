import semmle.code.csharp.security.dataflow.flowsinks.ExternalLocationSink
import semmle.code.csharp.commons.Diagnostics

from ExternalLocationSink sink
where sink.getLocation().getFile().fromSource()
select sink, sink.getExpr()

query predicate compilationErrors(CompilerError e) { any() }

query predicate methodCalls(MethodCall m) { any() }
