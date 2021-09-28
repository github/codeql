import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newRBWithMapValue;;;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;newRBWithMapKey;;;Argument[0];MapKey of ReturnValue;value"
      ]
  }
}
