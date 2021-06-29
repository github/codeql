import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import CsvValidation

class SourceModelTest extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; output; kind`
        "my.qltest;A;false;src1;();;ReturnValue;qltest",
        "my.qltest;A;false;src1;(String);;ReturnValue;qltest",
        "my.qltest;A;false;src1;(java.lang.String);;ReturnValue;qltest-alt",
        "my.qltest;A;false;src1;;;ReturnValue;qltest-all-overloads",
        "my.qltest;A;false;src2;();;ReturnValue;qltest",
        "my.qltest;A;false;src3;();;ReturnValue;qltest",
        "my.qltest;A;true;src2;();;ReturnValue;qltest-w-subtypes",
        "my.qltest;A;true;src3;();;ReturnValue;qltest-w-subtypes",
        "my.qltest;A;false;srcArg;(Object);;Argument[0];qltest-argnum",
        "my.qltest;A;false;srcArg;(Object);;Argument;qltest-argany",
        "my.qltest;A$Handler;true;handle;(Object);;Parameter[0];qltest-param-override",
        "my.qltest;A$Tag;false;;;Annotated;ReturnValue;qltest-retval",
        "my.qltest;A$Tag;false;;;Annotated;Parameter;qltest-param",
        "my.qltest;A$Tag;false;;;Annotated;;qltest-nospec",
        "my.qltest;A;false;srcTwoArg;(String,String);;ReturnValue;qltest-shortsig",
        "my.qltest;A;false;srcTwoArg;(java.lang.String,java.lang.String);;ReturnValue;qltest-longsig"
      ]
  }
}

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
