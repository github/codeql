import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        ";B;false;readElement;(Spliterator);;Argument[0].Element;ReturnValue;value",
        ";B;false;readElement;(Stream);;Argument[0].Element;ReturnValue;value"
      ]
  }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { none() }
}
