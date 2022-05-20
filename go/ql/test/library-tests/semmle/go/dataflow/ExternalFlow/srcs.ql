import go
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.ExternalFlow
import CsvValidation

class SourceModelTest extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; output; kind`
        "github.com/nonexistent/test;A;false;Src1;;;ReturnValue;qltest",
        "github.com/nonexistent/test;A;false;Src2;;;ReturnValue;qltest",
        "github.com/nonexistent/test;A;true;Src2;;;ReturnValue;qltest-w-subtypes",
        "github.com/nonexistent/test;A;false;SrcArg;;;Argument[0];qltest-arg",
        "github.com/nonexistent/test;A;false;Src3;;;ReturnValue[0];qltest",
        "github.com/nonexistent/test;A;true;Src3;;;ReturnValue[1];qltest-w-subtypes"
      ]
  }
}

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
