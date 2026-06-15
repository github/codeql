/**
 * This query is meant to catch the flows from `CUSTOM_SOURCE` to `CUSTOM_SINK`.
 *
 * This should be compared to
 * python/ql/test/library-tests/taint/dataflow/Dataflow.ql
 * A first goal is to have identical results; after that we
 * hope to remove the false positive.
 */

import python
import semmle.python.dataflow.new.DataFlow

module CustomTestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asCfgNode().(NameNode).getId() = "CUSTOM_SOURCE" }

  predicate isSink(DataFlow::Node node) {
    exists(CallNode call |
      call.getFunction().(NameNode).getId() in ["CUSTOM_SINK", "CUSTOM_SINK_F"] and
      node.asCfgNode() = call.getAnArg()
    )
  }
}

module CustomTestFlow = DataFlow::Global<CustomTestConfig>;

from DataFlow::Node source, DataFlow::Node sink
where CustomTestFlow::flow(source, sink)
select source, sink
