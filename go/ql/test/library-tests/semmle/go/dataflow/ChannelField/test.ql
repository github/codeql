import go
import TestUtilities.InlineFlowTest

module Flow = DataFlow::Global<DefaultFlowConfig>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select source, source, sink, "path"
