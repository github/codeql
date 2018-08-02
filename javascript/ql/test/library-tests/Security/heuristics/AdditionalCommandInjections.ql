import javascript
import semmle.javascript.security.dataflow.CommandInjection::CommandInjection

private import semmle.javascript.heuristics.all
// tests that the imports above changes the behavior of the standard taint tracking query

from Configuration cfg, Source source, Sink sink
where cfg.hasFlow(source, sink)
select sink, source
