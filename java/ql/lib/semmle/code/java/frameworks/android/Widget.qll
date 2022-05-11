/** Provides classes and predicates for working with Android widgets. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources

private class AndroidWidgetSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row = "android.widget;EditText;true;getText;;;ReturnValue;android-widget"
  }
}

private class DefaultAndroidWidgetSources extends RemoteFlowSource {
  DefaultAndroidWidgetSources() { sourceNode(this, "android-widget") }

  override string getSourceType() { result = "Android widget source" }
}

private class EditableToStringStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess toString |
      toString.getMethod().hasName("toString") and
      toString.getReceiverType().hasQualifiedName("android.text", "Editable")
    |
      n1.asExpr() = toString.getQualifier() and
      n2.asExpr() = toString
    )
  }
}

private class AndroidWidgetSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row = "android.widget;EditText;true;getText;;;Argument[-1];ReturnValue;taint"
  }
}
