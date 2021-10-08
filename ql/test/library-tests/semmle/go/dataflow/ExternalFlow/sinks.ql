import go
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.ExternalFlow
import CsvValidation

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; input; kind`
        "github.com/nonexistent/test;B;false;Sink1;;;Argument[0];qltest",
        "github.com/nonexistent/test;B;false;SinkMethod;;;ReturnValue;qltest"
      ]
  }
}

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
