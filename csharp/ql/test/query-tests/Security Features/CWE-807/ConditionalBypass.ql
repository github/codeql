/**
 * @kind path-problem
 */

import csharp
import semmle.code.csharp.security.dataflow.ConditionalBypassQuery
import codeql.dataflow.test.ProvenancePathGraph
import semmle.code.csharp.dataflow.internal.ExternalFlow
import ShowProvenance<interpretModelForTest/2, ConditionalBypass::PathNode, ConditionalBypass::PathGraph>

from ConditionalBypass::PathNode source, ConditionalBypass::PathNode sink
where ConditionalBypass::flowPath(source, sink)
select sink.getNode(), source, sink, "This condition guards a sensitive $@, but a $@ controls it.",
  sink.getNode().(Sink).getSensitiveMethodCall(), "action", source.getNode(), "user-provided value"
