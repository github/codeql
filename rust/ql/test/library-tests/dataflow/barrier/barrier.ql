import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { none() }

  predicate isSink(DataFlow::Node sink) { none() }

  predicate isBarrier(DataFlow::Node n) { none() }
}

module Tainted = TaintTracking::Global<FlowConfig>;

from Tainted::PathNode source, Tainted::PathNode sink
where Tainted::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
