import javascript
import semmle.javascript.heuristics.AdditionalSources
import semmle.javascript.security.dataflow.CodeInjectionQuery
import CodeInjectionFlow::PathGraph

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
where CodeInjectionFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "$@ flows to here and is interpreted as code.",
  source.getNode(), "User-provided value"
