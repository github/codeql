/**
 * Provides classes for working with GWT-generated code.
 */

import javascript

/**
 * A `$gwt_version` variable.
 */
class GwtVersionVariable extends GlobalVariable {
  GwtVersionVariable() { this.getName() = "$gwt_version" }
}

/**
 * A GWT header script that defines the `$gwt_version` variable.
 */
class GwtHeader extends InlineScript {
  GwtHeader() {
    exists(GwtVersionVariable gwtVersion | gwtVersion.getADeclaration().getTopLevel() = this)
  }

  /**
   * Gets the GWT version this script was generated with, if it can be determined.
   */
  string getGwtVersion() {
    exists(Expr e | e.getTopLevel() = this |
      e = any(GwtVersionVariable v).getAnAssignedExpr() and
      result = e.getStringValue()
    )
  }
}

/**
 * A toplevel in a file that appears to be GWT-generated.
 */
class GwtGeneratedTopLevel extends TopLevel {
  GwtGeneratedTopLevel() { exists(GwtHeader h | this.getFile() = h.getFile()) }
}
