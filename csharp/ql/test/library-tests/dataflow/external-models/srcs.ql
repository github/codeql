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
        "My.Qltest;A;false;Src1;();;ReturnValue;qltest",
        "My.Qltest;A;false;Src1;(System.String);;ReturnValue;qltest",
        "My.Qltest;A;false;Src1;;;ReturnValue;qltest-all-overloads",
        "My.Qltest;A;false;Src2;();;ReturnValue;qltest",
        "My.Qltest;A;false;Src3;();;ReturnValue;qltest",
        "My.Qltest;A;true;Src2;();;ReturnValue;qltest-w-subtypes",
        "My.Qltest;A;true;Src3;();;ReturnValue;qltest-w-subtypes",
        "My.Qltest;A;false;SrcArg;(System.Object);;Argument[0];qltest-argnum",
        "My.Qltest;A;false;SrcArg;(System.Object);;Argument;qltest-argany",
        "My.Qltest;A;true;SrcParam;(System.Object);;Parameter[0];qltest-param-override",
        "My.Qltest;SourceAttribute;false;;;Attribute;ReturnValue;qltest-retval",
        "My.Qltest;SourceAttribute;false;;;Attribute;Parameter;qltest-param",
        "My.Qltest;SourceAttribute;false;;;Attribute;;qltest-nospec",
        "My.Qltest;A;false;SrcTwoArg;(System.String,System.String);;ReturnValue;qltest"
      ]
  }
}

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
