import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.security.CommandInjection
import codeql.dataflow.test.ProvenancePathGraph
import ShowProvenance<interpretModelForTest/2, CommandInjection::Flow::PathNode, CommandInjection::Flow::PathGraph>

from CommandInjection::Flow::PathNode source, CommandInjection::Flow::PathNode sink
where CommandInjection::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
