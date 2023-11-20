import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TestUtilities.InlineExpectationsTest
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

signature class LegacyConfiguration extends DataFlow::Configuration;

module GetQueryTest {
  module FromDataFlowConfig<DataFlow::ConfigSig C> implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) }

    predicate flowTo(DataFlow::Node sink) { DataFlow::Global<C>::flowTo(sink) }
  }

  module FromDataFlowStateConfig<DataFlow::StateConfigSig C> implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) or C::isSink(sink, _) }

    predicate flowTo(DataFlow::Node sink) { DataFlow::GlobalWithState<C>::flowTo(sink) }
  }

  module FromTaintTrackingConfig<DataFlow::ConfigSig C> implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) }

    predicate flowTo(DataFlow::Node sink) { TaintTracking::Global<C>::flowTo(sink) }
  }

  module FromTaintTrackingStateConfig<DataFlow::StateConfigSig C> implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { C::isSink(sink) or C::isSink(sink, _) }

    predicate flowTo(DataFlow::Node sink) { TaintTracking::GlobalWithState<C>::flowTo(sink) }
  }

  module FromLegacyConfiguration<LegacyConfiguration C> implements QueryTestSig {
    predicate isSink(DataFlow::Node sink) { any(C c).isSink(sink) or any(C c).isSink(sink, _) }

    predicate flowTo(DataFlow::Node sink) { any(C c).hasFlowTo(sink) }
  }
}

module FromDataFlowConfig<DataFlow::ConfigSig C> {
  import MakeQueryTest<GetQueryTest::FromDataFlowConfig<C>>
}

module FromDataFlowStateConfig<DataFlow::StateConfigSig C> {
  import MakeQueryTest<GetQueryTest::FromDataFlowStateConfig<C>>
}

module FromTaintTrackingConfig<DataFlow::ConfigSig C> {
  import MakeQueryTest<GetQueryTest::FromTaintTrackingConfig<C>>
}

module FromTaintTrackingStateConfig<DataFlow::StateConfigSig C> {
  import MakeQueryTest<GetQueryTest::FromTaintTrackingStateConfig<C>>
}

module FromLegacyConfiguration<LegacyConfiguration C> {
  import MakeQueryTest<GetQueryTest::FromLegacyConfiguration<C>>
}

module IgnoreAbsolutePaths<QueryTestSig C> implements QueryTestSig {
  predicate isSink(DataFlow::Node sink) {
    C::isSink(sink) and exists(sink.getLocation().getFile().getRelativePath())
  }

  predicate flowTo(DataFlow::Node sink) {
    C::flowTo(sink) and exists(sink.getLocation().getFile().getRelativePath())
  }
}
