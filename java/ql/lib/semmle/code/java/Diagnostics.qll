/**
 * Provides classes representing warnings generated during compilation.
 */

import java

/** A compiler-generated error, warning or remark. */
class Diagnostic extends @diagnostic {
  /** Gets the compilation that generated this diagnostic. */
  Compilation getCompilation() { diagnostic_for(this, result, _, _) }

  /** Gets the compilation information for this diagnostic. */
  predicate getCompilationInfo(Compilation c, int fileNumber, int diagnosticNumber) {
    diagnostic_for(this, c, fileNumber, diagnosticNumber)
  }

  /**
   * Gets the program that generated this diagnostic.
   */
  string getGeneratedBy() { diagnostics(this, result, _, _, _, _, _) }

  /**
   * Gets the severity of the message.
   *
   * For Java, this ranges from 1 to 8:
   * 1=warning(low)
   * 2=warning(normal)
   * 3=warning(high)
   * 4=error(low)    Minor extractor errors, with minimal impact on analysis
   * 5=error(normal) Most extractor errors, with local impact on analysis
   * 6=error(high)   Errors from the frontend
   * 7=error(severe) Severe extractor errors affecting a single source file
   * 8=error(global) Severe extractor errors likely to affect multiple source files
   * For Kotlin, only the "normal" warning and error severities are used.
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
