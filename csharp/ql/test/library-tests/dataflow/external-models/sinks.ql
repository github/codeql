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
        "My.Qltest;B;false;Sink1;(System.Object);;Argument[0];code",
        "My.Qltest;B;false;SinkMethod;();;ReturnValue;xss",
        "My.Qltest;SinkAttribute;false;;;Attribute;ReturnValue;html",
        "My.Qltest;SinkAttribute;false;;;Attribute;Argument;remote",
        "My.Qltest;SinkAttribute;false;;;Attribute;;sql"
      ]
  }
}

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
