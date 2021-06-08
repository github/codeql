import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "my.qltest;C;false;stepArgRes;(Object);;Argument[0];ReturnValue;taint",
        "my.qltest;C;false;stepArgArg;(Object,Object);;Argument[0];Argument[1];taint",
        "my.qltest;C;false;stepArgQual;(Object);;Argument[0];Argument[-1];taint",
        "my.qltest;C;false;stepQualRes;();;Argument[-1];ReturnValue;taint",
        "my.qltest;C;false;stepQualArg;(Object);;Argument[-1];Argument[0];taint"
      ]
  }
}

from DataFlow::Node node1, DataFlow::Node node2
where FlowSummaryImpl::Private::Steps::summaryThroughStep(node1, node2, false)
select node1, node2
