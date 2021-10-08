import java
import semmle.code.java.frameworks.android.Intent
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;getMapKeyDefault;(Bundle);;MapKey of Argument[0];ReturnValue;value"
      ]
  }
}

class NotificationsTaintFlowConf extends DefaultTaintFlowConf {
  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content c) {
    super.allowImplicitRead(node, c)
    or
    isSink(node) and
    c.(DataFlow::SyntheticFieldContent).getField() = "android.app.Notification.action"
    or
    allowIntentExtrasImplicitRead(node, c)
  }
}
