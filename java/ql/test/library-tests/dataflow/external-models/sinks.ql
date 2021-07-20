import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import CsvValidation

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; kind`
        "my.qltest;B;false;sink1;(Object);;Argument[0];qltest",
        "my.qltest;B;false;sinkMethod;();;ReturnValue;qltest",
        "my.qltest;B$Tag;false;;;Annotated;ReturnValue;qltest-retval",
        "my.qltest;B$Tag;false;;;Annotated;Argument;qltest-arg",
        "my.qltest;B$Tag;false;;;Annotated;;qltest-nospec"
      ]
  }
}

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
