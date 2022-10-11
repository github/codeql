import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import CsvValidation

class SourceModelTest extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; output; kind`
        "my.qltest;A;false;src1;();;ReturnValue;qltest;manual",
        "my.qltest;A;false;src1;(String);;ReturnValue;qltest;manual",
        "my.qltest;A;false;src1;(java.lang.String);;ReturnValue;qltest-alt;manual",
        "my.qltest;A;false;src1;;;ReturnValue;qltest-all-overloads;manual",
        "my.qltest;A;false;src2;();;ReturnValue;qltest;manual",
        "my.qltest;A;false;src3;();;ReturnValue;qltest;manual",
        "my.qltest;A;true;src2;();;ReturnValue;qltest-w-subtypes;manual",
        "my.qltest;A;true;src3;();;ReturnValue;qltest-w-subtypes;manual",
        "my.qltest;A;false;srcArg;(Object);;Argument[0];qltest-argnum;manual",
        "my.qltest;A;false;srcArg;(Object);;Argument;qltest-argany;manual",
        "my.qltest;A$Handler;true;handle;(Object);;Parameter[0];qltest-param-override;manual",
        "my.qltest;A$Tag;false;;;Annotated;ReturnValue;qltest-retval;manual",
        "my.qltest;A$Tag;false;;;Annotated;Parameter;qltest-param;manual",
        "my.qltest;A$Tag;false;;;Annotated;;qltest-nospec;manual",
        "my.qltest;A;false;srcTwoArg;(String,String);;ReturnValue;qltest-shortsig;manual",
        "my.qltest;A;false;srcTwoArg;(java.lang.String,java.lang.String);;ReturnValue;qltest-longsig;manual"
      ]
  }
}

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
