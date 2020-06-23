/**
 * Provides classes representing warnings generated during compilation.
 */

import semmle.code.cpp.Location

/** A compiler-generated error, warning or remark. */
class Diagnostic extends Locatable, @diagnostic {
  /**
   * Gets the severity of the message, on a range from 1 to 5: 1=remark,
   * 2=warning, 3=discretionary error, 4=error, 5=catastrophic error.
   */
  int getSeverity() { diagnostics(underlyingElement(this), result, _, _, _, _) }

  /** Gets the error code for this compiler message. */
  string getTag() { diagnostics(underlyingElement(this), _, result, _, _, _) }

  /** Holds if `s` is the error code for this compiler message. */
  predicate hasTag(string s) { this.getTag() = s }

  /**
   * Gets the error message text associated with this compiler
   * diagnostic.
   */
  string getMessage() { diagnostics(underlyingElement(this), _, _, result, _, _) }

  /**
   * Gets the full error message text associated with this compiler
   * diagnostic.
   */
  string getFullMessage() { diagnostics(underlyingElement(this), _, _, _, result, _) }

  /** Gets the source location corresponding to the compiler message. */
  override Location getLocation() { diagnostics(underlyingElement(this), _, _, _, _, result) }

  override string toString() { result = this.getMessage() }
}

/** A compiler-generated remark (milder than a warning). */
class CompilerRemark extends Diagnostic {
  CompilerRemark() { this.getSeverity() = 1 }
}

/** A compiler-generated warning. */
class CompilerWarning extends Diagnostic {
  CompilerWarning() { this.getSeverity() = 2 }
}

/**
 * A compiler-generated discretionary error (a compile-time error that may
 * be suppressed).
 */
class CompilerDiscretionaryError extends Diagnostic {
  CompilerDiscretionaryError() { this.getSeverity() = 3 }
}

/** A compiler error message. */
class CompilerError extends Diagnostic {
  CompilerError() { this.getSeverity() = 4 }
}

/** A compiler error that prevents compilation from continuing. */
class CompilerCatastrophe extends Diagnostic {
  CompilerCatastrophe() { this.getSeverity() = 5 }
}
