/**
 * Provides classes representing warnings generated during compilation.
 */

import java

/** A compiler-generated error, warning or remark. */
class Diagnostic extends @diagnostic {
  /** Gets the compilation that generated this diagnostic. */
  Compilation getCompilation() { diagnostic_for(this, result, _, _) }

  /**
   * Gets the program that generated this diagnostic.
   */
  string getGeneratedBy() { diagnostics(this, result, _, _, _, _, _) }

  /**
   * Gets the severity of the message, on a range from 1 to 5: 1=remark,
   * 2=warning, 3=discretionary error, 4=error, 5=catastrophic error.
   */
  int getSeverity() { diagnostics(this, _, result, _, _, _, _) }

  /** Gets the error code for this compiler message. */
  string getTag() { diagnostics(this, _, _, result, _, _, _) }

  /** Holds if `s` is the error code for this compiler message. */
  predicate hasTag(string s) { this.getTag() = s }

  /**
   * Gets the error message text associated with this compiler
   * diagnostic.
   */
  string getMessage() { diagnostics(this, _, _, _, result, _, _) }

  /**
   * Gets the full error message text associated with this compiler
   * diagnostic.
   */
  string getFullMessage() { diagnostics(this, _, _, _, _, result, _) }

  /** Gets the source location corresponding to the compiler message. */
  Location getLocation() { diagnostics(this, _, _, _, _, _, result) }

  /** Gets a textual representation of this diagnostic. */
  string toString() { result = this.getMessage() }
}
