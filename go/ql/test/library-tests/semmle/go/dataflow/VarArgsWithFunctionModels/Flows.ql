import go
import semmle.go.dataflow.ExternalFlow
import CsvValidation
// import DataFlow::PartialPathGraph
import TestUtilities.InlineExpectationsTest

class SummaryModelTest extends DataFlow::FunctionModel {
  FunctionInput inp;
  FunctionOutput outp;

  SummaryModelTest() {
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithParameter") and
    (inp.isParameter(0) and outp.isResult())
    or
    // Cannot model this correctly for data flow, but it should work for taint flow
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithSliceParameter") and
    (inp.isParameter(0) and outp.isResult())
    or
    this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithVarArgsParameter") and
    (inp.isParameter(_) and outp.isResult())
    // or
    // this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithSliceOfStructsParameter")) and
    // (inp.isParameter(0) and outp.isResult)
    // or
    // this.hasQualifiedName("github.com/nonexistent/test", "FunctionWithVarArgsOfStructsParameter")) and
    // (inp.isParameter(0) and outp.isResult)
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    input = inp and output = outp
  }
}

class DataConfiguration extends DataFlow::Configuration {
  DataConfiguration() { this = "data-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(DataFlow::CallNode c | c.getCalleeName() = "source").getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getArgument(0)
  }

  override int explorationLimit() { result = 10 } // this is different!
}

class DataFlowTest extends InlineExpectationsTest {
  DataFlowTest() { this = "DataFlowTest" }

  override string getARelevantTag() { result = "dataflow" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "dataflow" and
    exists(DataFlow::Node sink | any(DataConfiguration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "" and
      sink.hasLocationInfo(file, line, _, _, _)
    )
  }
}

class TaintConfiguration extends TaintTracking::Configuration {
  TaintConfiguration() { this = "taint-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(DataFlow::CallNode c | c.getCalleeName() = "source").getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getArgument(0)
  }

  override int explorationLimit() { result = 10 } // this is different!
}

class TaintFlowTest extends InlineExpectationsTest {
  TaintFlowTest() { this = "TaintFlowTest" }

  override string getARelevantTag() { result = "taintflow" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "taintflow" and
    exists(DataFlow::Node sink | any(TaintConfiguration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "" and
      sink.hasLocationInfo(file, line, _, _, _)
    )
  }
}
// from TaintConfiguration cfg, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
// where
//   cfg.hasPartialFlow(source, sink, _)
//   and
//   source.getNode().hasLocationInfo(_, 22, _, _, _)
// select sink, source, sink, "Partial flow from unsanitized user data"
