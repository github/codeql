/** Provides classes and predicates for working with Android widgets. */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSources

private class AndroidWidgetSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row = "android.widget;EditText;true;getText;;;ReturnValue;android-widget"
  }
}

private class DefaultAndroidWidgetSources extends RemoteFlowSource {
  DefaultAndroidWidgetSources() { sourceNode(this, "android-widget") }

  override string getSourceType() { result = "Android widget source" }
}

private class AndroidWidgetSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row = "android.widget;EditText;true;getText;;;Argument[-1];ReturnValue;taint"
  }
}
