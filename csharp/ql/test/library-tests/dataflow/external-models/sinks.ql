import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import CsvValidation

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;spec;kind",
        "My.Qltest;B;false;Sink1;(System.Object);;Argument[0];qltest",
        "My.Qltest;B;false;SinkMethod;();;ReturnValue;qltest",
        "My.Qltest;SinkAttribute;false;;;Attribute;ReturnValue;qltest-retval",
        "My.Qltest;SinkAttribute;false;;;Attribute;Argument;qltest-arg",
        "My.Qltest;SinkAttribute;false;;;Attribute;;qltest-nospec"
      ]
  }
}

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
