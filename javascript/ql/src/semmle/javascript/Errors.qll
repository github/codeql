/** Provides classes for working with syntax errors. */

import javascript

/** An error encountered during extraction. */
abstract class Error extends Locatable {
  override Location getLocation() { hasLocation(this, result) }

  /** Gets the message associated with this error. */
  abstract string getMessage();

  override string toString() { result = getMessage() }
}

/** A JavaScript parse error encountered during extraction. */
class JSParseError extends @js_parse_error, Error {
  /** Gets the toplevel element this error occurs in. */
  TopLevel getTopLevel() { js_parse_errors(this, result, _, _) }

  override string getMessage() { js_parse_errors(this, _, result, _) }

  /** Gets the source text of the line this error occurs on. */
  string getLine() { js_parse_errors(this, _, _, result) }
}
