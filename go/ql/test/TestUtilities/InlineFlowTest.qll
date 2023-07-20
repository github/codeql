/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import go
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
 * Example of the corresponding test file, e.g. Test.go
 * ```go
 * func source() string { return ""; }
 * func taint() string { return ""; }
 * func sink(s string) { }
 *
 * func test() {
 *   s := source()
 *   sink(s) // $ hasValueFlow="s"
 *   t := "foo" + taint()
 *   sink(t) // $ hasTaintFlow="t"
 * }
 * ```
 *
 * If you are only interested in value flow, then instead of importing `DefaultFlowTest`, you can import
 * `ValueFlowTest<DefaultFlowConfig>`. Similarly, if you are only interested in taint flow, then instead of
 * importing `DefaultFlowTest`, you can import `TaintFlowTest<DefaultFlowConfig>`. In both cases
 * `DefaultFlowConfig` can be replaced by another implementation of `DataFlow::ConfigSig`.
 *
 * If you need more fine-grained tuning, consider implementing a test using `InlineExpectationsTest`.
 */

import go
import TestUtilities.InlineExpectationsTest

private predicate defaultSource(DataFlow::Node source) {
  exists(Function fn | fn.hasQualifiedName(_, ["source", "taint"]) |
    source = fn.getACall().getResult()
  )
}

private predicate defaultSink(DataFlow::Node sink) {
  exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
}

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
      exists(DataFlow::Node sink | ValueFlow::flowTo(sink) |
        sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = sink.toString() and
        value = "\"" + sink.toString() + "\""
      )
      or
      tag = "hasTaintFlow" and
      exists(DataFlow::Node src, DataFlow::Node sink |
        TaintFlow::flow(src, sink) and not ValueFlow::flow(src, sink)
      |
        sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = sink.toString() and
        value = "\"" + sink.toString() + "\""
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
