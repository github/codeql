import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newWithMapKeyDefault;(Object);;Argument[0];MapKey of ReturnValue;value",
        "generatedtest;Test;false;getMapKeyDefault;(Object);;MapKey of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapValueDefault;(Object);;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;getMapValueDefault;(Object);;MapValue of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithIntent_extrasDefault;(Object);;Argument[0];SyntheticField[android.content.Intent.extras] of ReturnValue;value",
        "generatedtest;Test;false;getIntent_extrasDefault;(Object);;SyntheticField[android.content.Intent.extras] of Argument[0];ReturnValue;value"
      ]
  }
}
