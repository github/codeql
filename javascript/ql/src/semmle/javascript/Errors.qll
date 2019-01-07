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
  TopLevel getTopLevel() { jsParseErrors(this, result, _, _) }

  override string getMessage() { jsParseErrors(this, _, result, _) }

  /** Gets the source text of the line this error occurs on. */
  string getLine() { jsParseErrors(this, _, _, result) }
}
