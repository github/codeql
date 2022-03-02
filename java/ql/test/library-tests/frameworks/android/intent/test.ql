import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newBundleWithMapValue;(Object);;Argument[0];ReturnValue.MapValue;value",
        "generatedtest;Test;false;newPersistableBundleWithMapValue;(Object);;Argument[0];ReturnValue.MapValue;value",
        "generatedtest;Test;false;getMapValue;(BaseBundle);;Argument[0].MapValue;ReturnValue;value",
        "generatedtest;Test;false;newWithIntent_extras;(Bundle);;Argument[0];ReturnValue.SyntheticField[android.content.Intent.extras];value"
      ]
  }
}
