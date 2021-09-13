import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        // This is temporarily modelled for the helper function newEnumerationWithElement, until the relevant package is modelled
        "org.apache.commons.collections4.iterators;IteratorEnumeration;true;IteratorEnumeration;;;Element of Argument[0];Element of Argument[-1];value",
        "generatedtest;Test;false;newRBWithMapValue;;;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;newRBWithMapKey;;;Argument[0];MapKey of ReturnValue;value"
      ]
  }
}
