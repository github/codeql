private import codeql.Locations

/** A diagnostic emitted during extraction, such as a parse error */
class Diagnostic extends @diagnostic {
  int severity;
  string tag;
  string message;
  string fullMessage;
  Location location;

  Diagnostic() { diagnostics(this, severity, tag, message, fullMessage, location) }

  /**
   * Gets the numerical severity level associated with this diagnostic.
   */
  int getSeverity() { result = severity }

  /** Gets a string representation of the severity of this diagnostic. */
  string getSeverityText() {
    severity = 0 and result = "Hidden"
    or
    severity = 1 and result = "Info"
    or
    severity = 2 and result = "Warning"
    or
    severity = 3 and result = "Error"
  }

  /** Gets the error code associated with this diagnostic, e.g. parse_error. */
  string getTag() { result = tag }

  /**
   * Gets the error message text associated with this diagnostic.
   */
  string getMessage() { result = message }

  /**
   * Gets the full error message text associated with this diagnostic.
   */
  string getFullMessage() { result = fullMessage }

  /** Gets the source location of this diagnostic. */
  Location getLocation() { result = location }

  /** Gets a textual representation of this diagnostic. */
  string toString() { result = this.getMessage() }
}

/** A diagnostic relating to a particular error in extracting a file. */
class ExtractionError extends Diagnostic {
  ExtractionError() {
    this.getSeverity() = 3 and
    this.getTag() = "parse_error"
  }
}
