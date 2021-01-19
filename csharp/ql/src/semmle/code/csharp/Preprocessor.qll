/**
 * Provides all preprocessor directive classes.
 */

import Element

class PreprocessorDirective extends Element, @preprocessor_directive {
  override Location getALocation() { preprocessor_directive_location(this, result) }
}

/**
 * A `#pragma warning` directive.
 */
class PragmaWarningDirective extends PreprocessorDirective, @pragma_warning {
  /** Holds if this is a `#pragma warning restore` directive. */
  predicate restore() { pragma_warnings(this, 1) }

  /** Holds if this is a `#pragma warning disable` directive. */
  predicate disable() { pragma_warnings(this, 0) }

  /** Holds if this directive specifies error codes. */
  predicate hasErrorCodes() { exists(string s | pragma_warning_error_codes(this, s, _)) }

  /** Gets a specified error code from this directive. */
  string getAnErrorCode() { pragma_warning_error_codes(this, result, _) }

  override string toString() { result = "#pragma warning ..." }

  override string getAPrimaryQlClass() { result = "PragmaWarningDirective" }
}
