import csharp
import Common

module Taint = TaintTracking::Global<FlowConfig>;

from DataFlow::Node source, DataFlow::Node sink
where Taint::flow(source, sink)
select sink
