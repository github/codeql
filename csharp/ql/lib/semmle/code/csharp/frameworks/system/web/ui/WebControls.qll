/** Provides definitions related to the namespace `System.Web.UI.WebControls`. */

import csharp
private import semmle.code.csharp.frameworks.system.web.UI
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Web.UI.WebControls` namespace. */
class SystemWebUIWebControlsNamespace extends Namespace {
  SystemWebUIWebControlsNamespace() {
    this.getParentNamespace() instanceof SystemWebUINamespace and
    this.hasName("WebControls")
  }
}

/** A class in the `System.Web.UI.WebControls` namespace. */
class SystemWebUIWebControlsClass extends Class {
  SystemWebUIWebControlsClass() { this.getNamespace() instanceof SystemWebUIWebControlsNamespace }
}

/** The `System.Web.UI.WebControls.TextBox` class. */
class SystemWebUIWebControlsTextBoxClass extends SystemWebUIWebControlsClass {
  SystemWebUIWebControlsTextBoxClass() { this.hasName("TextBox") }

  /** Gets the `Text` property. */
  Property getTextProperty() {
    result.getDeclaringType() = this and
    result.hasName("Text") and
    result.getType() instanceof StringType
  }
}

/** Data flow for `System.Web.UI.WebControls.TextBox`. */
private class SystebWebUIWebControlsTextBoxClassFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Web.UI.WebControls;TextBox;false;get_Text;();;Argument[Qualifier];ReturnValue;taint"
  }
}

/** The `System.Web.UI.WebControls.Label` class. */
class SystemWebUIWebControlsLabelClass extends SystemWebUIWebControlsClass {
  SystemWebUIWebControlsLabelClass() { this.hasName("Label") }

  /** Gets the `Text` property. */
  Property getTextProperty() {
    result.getDeclaringType() = this and
    result.hasName("Text") and
    result.getType() instanceof StringType
  }
}
