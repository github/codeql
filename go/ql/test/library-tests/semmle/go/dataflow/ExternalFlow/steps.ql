import go
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.ExternalFlow
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; input; output; kind`
        "github.com/nonexistent/test;T;false;StepArgRes;;;Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;T;false;StepArgRes1;;;Argument[0];ReturnValue[1];taint",
        "github.com/nonexistent/test;T;false;StepArgArg;;;Argument[0];Argument[1];taint",
        "github.com/nonexistent/test;T;false;StepArgQual;;;Argument[0];Argument[-1];taint",
        "github.com/nonexistent/test;T;false;StepQualRes;;;Argument[-1];ReturnValue;taint",
        "github.com/nonexistent/test;T;false;StepQualArg;;;Argument[-1];Argument[0];taint",
        "github.com/nonexistent/test;;false;StepArgResNoQual;;;Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgResContent;;;Argument[0];ReturnValue.ArrayElement;taint",
        "github.com/nonexistent/test;;false;StepArgContentRes;;;Argument[0].ArrayElement;ReturnValue;taint"
      ]
  }
}

from DataFlow::Node node1, DataFlow::Node node2
where FlowSummaryImpl::Private::Steps::summaryThroughStep(node1, node2, false)
select node1, node2
