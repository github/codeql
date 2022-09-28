/**
 * Provides classes for working with GWT-generated code.
 */

import javascript

/**
 * A `$gwt_version` variable.
 */
class GwtVersionVariable extends GlobalVariable {
  GwtVersionVariable() { getName() = "$gwt_version" }
}

/** DEPRECATED: Alias for GwtVersionVariable */
deprecated class GWTVersionVariable = GwtVersionVariable;

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

  /** DEPRECATED: Alias for getGwtVersion */
  deprecated string getGWTVersion() { result = getGwtVersion() }
}

/** DEPRECATED: Alias for GwtHeader */
deprecated class GWTHeader = GwtHeader;

/**
 * A toplevel in a file that appears to be GWT-generated.
 */
class GwtGeneratedTopLevel extends TopLevel {
  GwtGeneratedTopLevel() { exists(GwtHeader h | getFile() = h.getFile()) }
}

/** DEPRECATED: Alias for GwtGeneratedTopLevel */
deprecated class GWTGeneratedTopLevel = GwtGeneratedTopLevel;
