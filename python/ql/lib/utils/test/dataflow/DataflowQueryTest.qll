import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

signature module QueryTestSig {
  predicate isSink(DataFlow::Node sink);

  predicate flowTo(DataFlow::Node sink);
}

module MakeQueryTest<QueryTestSig Impl> {
  module DataFlowQueryTest implements TestSig {
    string getARelevantTag() { result = "result" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(DataFlow::Node sink | Impl::flowTo(sink) |
        location = sink.getLocation() and
        tag = "result" and
        value = "BAD" and
        element = sink.toString()
      )
    }

    // We allow annotating any sink with `result=OK` to signal
    // safe sinks.
    // Sometimes a line contains both an alert and a safe sink.
    // In this situation, the annotation form `OK(safe sink)`
    // can be useful.
    predicate hasOptionalResult(Location location, string element, string tag, string value) {
      exists(DataFlow::Node sink | Impl::isSink(sink) |
        location = sink.getLocation() and
        tag = "result" and
        value in ["OK", "OK(" + prettyNode(sink) + ")"] and
        element = sink.toString()
      )
    }
  }

  import MakeTest<DataFlowQueryTest>

  query predicate missingAnnotationOnSink(Location location, string error, string element) {
    error = "ERROR, you should add `# $ MISSING: result=BAD` or `result=OK` annotation" and
    exists(DataFlow::Node sink |
      exists(sink.getLocation().getFile().getRelativePath()) and
      Impl::isSink(sink) and
      location = sink.getLocation() and
      element = prettyExpr(sink.asExpr()) and
      not Impl::flowTo(sink) and
      not exists(FalseNegativeTestExpectation missingResult |
        missingResult.getTag() = "result" and
        missingResult.getValue() = "BAD" and
        missingResult.getLocation().getFile() = location.getFile() and
        missingResult.getLocation().getStartLine() = location.getStartLine()
      ) and
      not exists(GoodTestExpectation okResult |
        okResult.getTag() = "result" and
        okResult.getValue() in ["OK", "OK(" + prettyNode(sink) + ")"] and
        okResult.getLocation().getFile() = location.getFile() and
        okResult.getLocation().getStartLine() = location.getStartLine()
      )
    )
  }
}

module FromDataFlowConfig<DataFlow::ConfigSig C> {
  module Impl implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) }

    predicate flowTo(DataFlow::Node sink) { DataFlow::Global<C>::flowTo(sink) }
  }

  import MakeQueryTest<Impl>
}

module FromDataFlowStateConfig<DataFlow::StateConfigSig C> {
  module Impl implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) or C::isSink(sink, _) }

    predicate flowTo(DataFlow::Node sink) { DataFlow::GlobalWithState<C>::flowTo(sink) }
  }

  import MakeQueryTest<Impl>
}

module FromTaintTrackingConfig<DataFlow::ConfigSig C> {
  module Impl implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) }

    predicate flowTo(DataFlow::Node sink) { TaintTracking::Global<C>::flowTo(sink) }
  }

  import MakeQueryTest<Impl>
}

module FromTaintTrackingStateConfig<DataFlow::StateConfigSig C> {
  module Impl implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) or C::isSink(sink, _) }

    predicate flowTo(DataFlow::Node sink) { TaintTracking::GlobalWithState<C>::flowTo(sink) }
  }

  import MakeQueryTest<Impl>
}
