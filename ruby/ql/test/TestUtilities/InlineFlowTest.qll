/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import TestUtilities.InlineFlowTest
 * import DefaultFlowTest
 * import PathGraph
 *
 * from PathNode source, PathNode sink
 * where flowPath(source, sink)
 * select sink, source, sink, "$@", source, source.toString()
 * ```
 *
 * To declare expectations, you can use the $hasTaintFlow or $hasValueFlow comments within the test source files.
 * Example of the corresponding test file, e.g. test.rb
 * ```rb
 * s = source(1)
 * sink(s); // $ hasValueFlow=1
 * t = "foo" + taint(2);
 * sink(t); // $ hasTaintFlow=2
 * ```
 *
 * If you are only interested in value flow, then instead of importing `DefaultFlowTest`, you can import
 * `ValueFlowTest<DefaultFlowConfig>`. Similarly, if you are only interested in taint flow, then instead of
 * importing `DefaultFlowTest`, you can import `TaintFlowTest<DefaultFlowConfig>`. In both cases
 * `DefaultFlowConfig` can be replaced by another implementation of `DataFlow::ConfigSig`.
 *
 * If you need more fine-grained tuning, consider implementing a test using `InlineExpectationsTest`.
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTestUtil

module DefaultFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { defaultSource(source) }

  predicate isSink(DataFlow::Node sink) { defaultSink(sink) }

  int fieldFlowBranchLimit() { result = 1000 }
}

private module NoFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { none() }

  predicate isSink(DataFlow::Node sink) { none() }
}

module FlowTest<DataFlow::ConfigSig ValueFlowConfig, DataFlow::ConfigSig TaintFlowConfig> {
  module ValueFlow = DataFlow::Global<ValueFlowConfig>;

  module TaintFlow = TaintTracking::Global<TaintFlowConfig>;

  private module InlineTest implements TestSig {
    string getARelevantTag() { result = ["hasValueFlow", "hasTaintFlow"] }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      tag = "hasValueFlow" and
      exists(DataFlow::Node src, DataFlow::Node sink | ValueFlow::flow(src, sink) |
        sink.getLocation() = location and
        element = sink.toString() and
        if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
      )
      or
      tag = "hasTaintFlow" and
      exists(DataFlow::Node src, DataFlow::Node sink |
        TaintFlow::flow(src, sink) and not ValueFlow::flow(src, sink)
      |
        sink.getLocation() = location and
        element = sink.toString() and
        if exists(getSourceArgString(src)) then value = getSourceArgString(src) else value = ""
      )
    }
  }

  import MakeTest<InlineTest>
  import DataFlow::MergePathGraph<ValueFlow::PathNode, TaintFlow::PathNode, ValueFlow::PathGraph, TaintFlow::PathGraph>

  predicate flowPath(PathNode source, PathNode sink) {
    ValueFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) or
    TaintFlow::flowPath(source.asPathNode2(), sink.asPathNode2())
  }
}

module DefaultFlowTest = FlowTest<DefaultFlowConfig, DefaultFlowConfig>;

module ValueFlowTest<DataFlow::ConfigSig ValueFlowConfig> {
  import FlowTest<ValueFlowConfig, NoFlowConfig>
}

module TaintFlowTest<DataFlow::ConfigSig TaintFlowConfig> {
  import FlowTest<NoFlowConfig, TaintFlowConfig>
}
