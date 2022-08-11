import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import CsvValidation

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; kind`
        "my.qltest;B;false;sink1;(Object);;Argument[0];qltest;manual",
        "my.qltest;B;false;sinkMethod;();;ReturnValue;qltest;manual",
        "my.qltest;B$Tag;false;;;Annotated;ReturnValue;qltest-retval;manual",
        "my.qltest;B$Tag;false;;;Annotated;Argument;qltest-arg;manual",
        "my.qltest;B$Tag;false;;;Annotated;;qltest-nospec;manual"
      ]
  }
}

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
