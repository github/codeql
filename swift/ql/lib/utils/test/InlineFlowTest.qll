/**
 * Provides a simple base test for flow-related tests using inline expectations.
 *
 * Example for a test.ql:
 * ```ql
 * import swift
 * import utils.test.InlineFlowTest
 * import DefaultFlowTest
 * import PathGraph
 *
 * from PathNode source, PathNode sink
 * where flowPath(source, sink)
 * select sink, source, sink, "$@", source, source.toString()
 * ```
 *
 * To declare expectations, you can use the $hasTaintFlow or $hasValueFlow comments within the test source files.
 * Example of the corresponding test file, e.g. Test.java
 * ```swift
 * func source(_ label: String) -> Any { return nil }
 * func taint(_ label: String) -> Any { return nil }
 * func sink(_ o: Any) { }
 *
 * func test() {
 *     let s = source("mySource")
 *     sink(s) // $ hasValueFlow=mySource
 *     let t = "foo" + taint("myTaint")
 *     sink(t); // $ hasTaintFlow=myTaint
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

import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow
import codeql.swift.dataflow.TaintTracking
import utils.test.InlineExpectationsTest

private predicate defaultSource(DataFlow::Node source) {
  source
      .asExpr()
      .(CallExpr)
      .getStaticTarget()
      .(Function)
      .getShortName()
      .matches(["source%", "taint"])
}

private predicate defaultSink(DataFlow::Node sink) {
  exists(CallExpr ca | ca.getStaticTarget().(Function).getShortName().matches("sink%") |
    sink.asExpr() = ca.getAnArgument().getExpr()
  )
}

module DefaultFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { defaultSource(source) }

  predicate isSink(DataFlow::Node sink) { defaultSink(sink) }
}

module NoFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { none() }

  predicate isSink(DataFlow::Node sink) { none() }
}

private signature string valueFlowTagSig();

private signature string taintFlowTagSig();

string defaultValueFlowTag() { result = "hasValueFlow" }

string defaultTaintFlowTag() { result = "hasTaintFlow" }

private string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  src.asExpr().(CallExpr).getAnArgument().getExpr().(StringLiteralExpr).getValue() = result
}

module FlowTest<
  DataFlow::ConfigSig ValueFlowConfig, DataFlow::ConfigSig TaintFlowConfig,
  valueFlowTagSig/0 valueFlowTag, taintFlowTagSig/0 taintFlowTag>
{
  module ValueFlow = DataFlow::Global<ValueFlowConfig>;

  module TaintFlow = TaintTracking::Global<TaintFlowConfig>;

  private module InlineTest implements TestSig {
    string getARelevantTag() { result = [valueFlowTag(), taintFlowTag()] }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      tag = valueFlowTag() and
      exists(DataFlow::Node src, DataFlow::Node sink | ValueFlow::flow(src, sink) |
        sink.getLocation() = location and
        element = sink.toString() and
        if exists(getSourceArgString(src))
        then value = getSourceArgString(src)
        else value = src.getLocation().getStartLine().toString()
      )
      or
      tag = taintFlowTag() and
      exists(DataFlow::Node src, DataFlow::Node sink |
        TaintFlow::flow(src, sink) and not ValueFlow::flow(src, sink)
      |
        sink.getLocation() = location and
        element = sink.toString() and
        if exists(getSourceArgString(src))
        then value = getSourceArgString(src)
        else value = src.getLocation().getStartLine().toString()
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

module DefaultFlowTest =
  FlowTest<DefaultFlowConfig, DefaultFlowConfig, defaultValueFlowTag/0, defaultTaintFlowTag/0>;

module ValueFlowTest<DataFlow::ConfigSig ValueFlowConfig> {
  import FlowTest<ValueFlowConfig, NoFlowConfig, defaultValueFlowTag/0, defaultTaintFlowTag/0>
}

module TaintFlowTest<DataFlow::ConfigSig TaintFlowConfig> {
  import FlowTest<NoFlowConfig, TaintFlowConfig, defaultValueFlowTag/0, defaultTaintFlowTag/0>
}
