/**
 * Provides classes for working with GWT-generated code.
 */

import javascript

/**
 * A `$gwt_version` variable.
 */
class GWTVersionVariable extends GlobalVariable {
  GWTVersionVariable() { getName() = "$gwt_version" }
}

/**
 * A GWT header script that defines the `$gwt_version` variable.
 */
class GWTHeader extends InlineScript {
  GWTHeader() {
    exists(GWTVersionVariable gwtVersion | gwtVersion.getADeclaration().getTopLevel() = this)
  }

  /**
   * Gets the GWT version this script was generated with, if it can be determined.
   */
  string getGWTVersion() {
    exists(Expr e | e.getTopLevel() = this |
      e = any(GWTVersionVariable v).getAnAssignedExpr() and
      result = e.getStringValue()
    )
  }
}

/**
 * A toplevel in a file that appears to be GWT-generated.
 */
class GWTGeneratedTopLevel extends TopLevel {
  GWTGeneratedTopLevel() { exists(GWTHeader h | getFile() = h.getFile()) }
}
