/** Provides definitions related to the namespace `System.Web.UI.WebControls`. */

import csharp
private import semmle.code.csharp.frameworks.system.web.UI

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
