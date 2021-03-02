import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "my.qltest;C;false;stepArgRes;(Object);;Argument[0];ReturnValue;qltest",
        "my.qltest;C;false;stepArgArg;(Object,Object);;Argument[0];Argument[1];qltest",
        "my.qltest;C;false;stepArgQual;(Object);;Argument[0];Argument[-1];qltest",
        "my.qltest;C;false;stepQualRes;();;Argument[-1];ReturnValue;qltest",
        "my.qltest;C;false;stepQualArg;(Object);;Argument[-1];Argument[0];qltest"
      ]
  }
}

from DataFlow::Node node1, DataFlow::Node node2, string kind
where summaryStep(node1, node2, kind)
select node1, node2, kind
