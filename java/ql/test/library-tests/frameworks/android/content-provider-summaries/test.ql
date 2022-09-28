import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newWithMapValueDefault;(Object);;Argument[0];ReturnValue.MapValue;value;manual",
        "generatedtest;Test;false;newWithMapKeyDefault;(Object);;Argument[0];ReturnValue.MapKey;value;manual",
        "generatedtest;Test;false;getMapValueDefault;(Object);;Argument[0].MapValue;ReturnValue;value;manual",
        "generatedtest;Test;false;getMapKeyDefault;(Object);;Argument[0].MapKey;ReturnValue;value;manual"
      ]
  }
}
