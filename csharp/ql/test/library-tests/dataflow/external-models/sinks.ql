import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import CsvValidation
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;spec;kind;provenance",
        "My.Qltest;B;false;Sink1;(System.Object);;Argument[0];code;manual",
        "My.Qltest;B;false;SinkMethod;();;ReturnValue;xss;manual",
        "My.Qltest;SinkAttribute;false;;;Attribute;ReturnValue;html;manual",
        "My.Qltest;SinkAttribute;false;;;Attribute;Argument;remote;manual",
        "My.Qltest;SinkAttribute;false;;;Attribute;;sql;manual"
      ]
  }
}

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
