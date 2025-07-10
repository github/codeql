/**
 * @kind path-problem
 */

import rust
import utils.test.InlineFlowTest
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.FlowSummary
import codeql.rust.dataflow.TaintTracking
import codeql.rust.dataflow.internal.FlowSummaryImpl
import codeql.rust.dataflow.FlowSource
import codeql.rust.dataflow.FlowSink
import PathGraph

query predicate invalidSpecComponent(SummarizedCallable sc, string s, string c) {
  (sc.propagatesFlow(s, _, _) or sc.propagatesFlow(_, s, _)) and
  Private::External::invalidSpecComponent(s, c)
}

// not defined in `models.ext.yml`, in order to test that we can also define
// models directly in QL
private class SummarizedCallableIdentity extends SummarizedCallable::Range {
  SummarizedCallableIdentity() { this = "repo::test::_::crate::identity" }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string provenance
  ) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true and
    provenance = "QL"
  }
}

module CustomConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    DefaultFlowConfig::isSource(source)
    or
    sourceNode(source, "test-source")
  }

  predicate isSink(DataFlow::Node sink) {
    DefaultFlowConfig::isSink(sink)
    or
    sinkNode(sink, "test-sink")
  }
}

import FlowTest<CustomConfig, CustomConfig>

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
