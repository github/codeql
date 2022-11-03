import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newWithElementDefault;(Object);;Argument[0];Element of ReturnValue;value",
        "generatedtest;Test;false;newWithMapKeyDefault;(Object);;Argument[0];MapKey of ReturnValue;value",
        "generatedtest;Test;false;newWithMapValueDefault;(Object);;Argument[0];MapValue of ReturnValue;value"
      ]
  }
}
