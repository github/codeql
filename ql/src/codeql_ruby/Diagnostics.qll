private import codeql.Locations

/** A diagnostic emitted during extraction, such as a parse error */
class Diagnostic extends @diagnostic {
  /**
   * Gets the numerical severity level associated with this diagnostic.
   */
  int getSeverity() { diagnostics(this, result, _, _, _, _) }

  /** Gets the error code associated with this diagnostic, e.g. parse_error. */
  string getTag() { diagnostics(this, _, result, _, _, _) }

  /**
   * Gets the error message text associated with this diagnostic.
   */
  string getMessage() { diagnostics(this, _, _, result, _, _) }

  /**
   * Gets the full error message text associated with this diagnostic.
   */
  string getFullMessage() { diagnostics(this, _, _, _, result, _) }

  /** Gets the source location of this diagnostic. */
  Location getLocation() { diagnostics(this, _, _, _, _, result) }

  string toString() { result = this.getMessage() }
}

class ExtractionError extends Diagnostic {
  ExtractionError() { this.getTag() = "parse_error" }
}