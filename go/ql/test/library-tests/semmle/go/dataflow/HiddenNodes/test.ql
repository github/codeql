import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineFlowTest
import codeql.dataflow.test.ProvenancePathGraph

module Flow = TaintTracking::Global<DefaultFlowConfig>;

import ShowProvenance<interpretModelForTest/2, Flow::PathNode, Flow::PathGraph>

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select source, source, sink, "Path"
