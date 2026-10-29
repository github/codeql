/** Provides classes relating to compilation and extraction diagnostics. */

import csharp
import Compilation

/** A diagnostic emitted by a compilation, such as a compilation warning or an error. */
class Diagnostic extends @diagnostic {
  /** Gets the compilation that generated this diagnostic. */
  Compilation getCompilation() { diagnostic_for(this, result, _, _) }

  int severity;
  string tag;
  string message;
  string fullMessage;
  Location location;

  Diagnostic() { diagnostics(this, severity, tag, message, fullMessage, location) }

  /**
   * Gets the severity of this diagnostic.
   * 0 = Hidden
   * 1 = Info
   * 2 = Warning
   * 3 = Error
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

  /** Gets the identifier of this diagnostic, for example "CS8019". */
  string getTag() { result = tag }

  /** Gets the short error message of this diagnostic. */
  string getMessage() { result = message }

  /** Gets the full error message of this diagnostic. */
  string getFullMessage() { result = fullMessage }

  /** Gets the location of this diagnostic. */
  Location getLocation() { result = location }

  /** Gets a textual representation of this diagnostic. */
  string toString() { result = this.getTag() + ": " + this.getFullMessage() }

  /** Gets the element associated with this diagnostic, if any. */
  Element getElement() { this.getLocation() = result.getLocation() }
}

/** A diagnostic that is a compilation error. */
class CompilerError extends Diagnostic {
  CompilerError() { this.getSeverity() >= 3 }
}

/** A message from an extractor. */
class ExtractorMessage extends @extractor_message {
  int severity;
  string origin;
  string text;
  string element;
  string stackTrace;
  Location location;

  ExtractorMessage() {
    extractor_messages(this, severity, origin, text, element, location, stackTrace)
  }

  /** Gets the severity of this message. */
  int getSeverity() { result = severity }

  /** Gets the name of the extractor that produced this message, for example, `C# extractor`. */
  string getOrigin() { result = origin }

  /** Gets the text of this message. */
  string getText() { result = text }

  /** Gets the textual representation of the entity that triggered this message. */
  string getElementText() { result = element }

  /** Gets a string containing a stack trace of the extractor, or the empty string if none available. */
  string getStackTrace() { result = stackTrace }

  /** Gets the location of the element. */
  Location getLocation() { result = location }

  /** Gets a textual representation of this message. */
  string toString() { result = text }

  /** Gets a string representation of the severity of this message. */
  string getSeverityText() {
    severity = 1 and result = "Trace"
    or
    severity = 2 and result = "Debug"
    or
    severity = 3 and result = "Info"
    or
    severity = 4 and result = "Warning"
    or
    severity = 5 and result = "Error"
  }

  /** Gets the element associated with this message, if any. */
  Element getElement() { this.getLocation() = result.getLocation() }
}

/** An error from an extractor. */
class ExtractorError extends ExtractorMessage {
  ExtractorError() { this.getSeverity() >= 5 }
}
