/**
 * @kind path-problem
 */

import rust
import utils.InlineFlowTest
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.FlowSummary
import codeql.rust.dataflow.TaintTracking
import codeql.rust.dataflow.internal.FlowSummaryImpl
import PathGraph

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlow(s, _, _) or sc.propagatesFlow(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

module CustomConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { DefaultFlowConfig::isSource(source) }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }
}

import FlowTest<CustomConfig, CustomConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
