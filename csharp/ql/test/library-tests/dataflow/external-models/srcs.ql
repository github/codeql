import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import CsvValidation

class SourceModelTest extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;overrides;name;signature;ext;spec;kind",
        "My.Qltest;A;false;Src1;();;ReturnValue;local",
        "My.Qltest;A;false;Src1;(System.String);;ReturnValue;local",
        "My.Qltest;A;false;Src1;;;ReturnValue;local",
        "My.Qltest;A;false;Src2;();;ReturnValue;local",
        "My.Qltest;A;false;Src3;();;ReturnValue;local",
        "My.Qltest;A;true;Src2;();;ReturnValue;local",
        "My.Qltest;A;true;Src3;();;ReturnValue;local",
        "My.Qltest;A;false;SrcArg;(System.Object);;Argument[0];local",
        "My.Qltest;A;false;SrcArg;(System.Object);;Argument;local",
        "My.Qltest;A;true;SrcParam;(System.Object);;Parameter[0];local",
        "My.Qltest;SourceAttribute;false;;;Attribute;ReturnValue;local",
        "My.Qltest;SourceAttribute;false;;;Attribute;Parameter;local",
        "My.Qltest;SourceAttribute;false;;;Attribute;;local",
        "My.Qltest;A;false;SrcTwoArg;(System.String,System.String);;ReturnValue;local"
      ]
  }
}

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
