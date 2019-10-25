import javascript
import semmle.javascript.heuristics.AdditionalSources
import semmle.javascript.security.dataflow.CodeInjection::CodeInjection
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "$@ flows to here and is interpreted as code.",
  source.getNode(), "User-provided value"
