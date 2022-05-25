import go
import semmle.go.dataflow.ExternalFlow
import CsvValidation
import TestUtilities.InlineExpectationsTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "github.com/nonexistent/test;;false;FunctionWithParameter;;;Argument[0];ReturnValue;value",
        "github.com/nonexistent/test;;false;FunctionWithSliceParameter;;;Argument[0].ArrayElement;ReturnValue;value",
        "github.com/nonexistent/test;;false;FunctionWithVarArgsParameter;;;Argument[0].ArrayElement;ReturnValue;value",
        "github.com/nonexistent/test;;false;FunctionWithSliceOfStructsParameter;;;Argument[0].ArrayElement.Field[github.com/nonexistent/test.A.Field];ReturnValue;value",
        "github.com/nonexistent/test;;false;FunctionWithVarArgsOfStructsParameter;;;Argument[0].ArrayElement.Field[github.com/nonexistent/test.A.Field];ReturnValue;value"
      ]
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
