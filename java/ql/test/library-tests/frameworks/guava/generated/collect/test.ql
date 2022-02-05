import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newWithElementDefault;(Object);;Argument[0];ReturnValue.Element;value",
        "generatedtest;Test;false;newWithMapKeyDefault;(Object);;Argument[0];ReturnValue.MapKey;value",
        "generatedtest;Test;false;newWithMapValueDefault;(Object);;Argument[0];ReturnValue.MapValue;value"
      ]
  }
}
