import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest

module Flow = TaintTracking::Global<DefaultFlowConfig>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select source, source, sink, "Path"
