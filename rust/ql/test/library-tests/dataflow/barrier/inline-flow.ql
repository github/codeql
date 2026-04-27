/**
 * @kind path-problem
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.FlowBarrier
import utils.test.InlineFlowTest

module CustomConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate isBarrier(DataFlow::Node n) { barrierNode(n, "test-barrier") }
}

import FlowTest<CustomConfig, CustomConfig>
import TaintFlow::PathGraph

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
