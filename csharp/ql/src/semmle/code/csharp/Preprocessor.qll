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

/**
 * A `#pragma checksum` directive.
 */
class PragmaChecksumDirective extends PreprocessorDirective, @pragma_checksum {
  /** Gets the file name of this directive. */
  string getFileName() { pragma_checksums(this, result, _, _) }

  /** Gets the GUID of this directive. */
  string getGuid() { pragma_checksums(this, _, result, _) }

  /** Gets the checksum bytes of this directive. */
  string getBytes() { pragma_checksums(this, _, _, result) }

  override string toString() { result = "#pragma checksum ..." }

  override string getAPrimaryQlClass() { result = "PragmaChecksumDirective" }
}

/**
 * An `#define` directive.
 */
class DefineDirective extends PreprocessorDirective, @directive_define {
  /** Gets the name of the preprocessor symbol that is being set by this directive. */
  string getName() { directive_defines(this, result) }

  override string toString() { result = "#define ..." }

  override string getAPrimaryQlClass() { result = "DefineDirective" }
}

/**
 * An `#undef` directive.
 */
class UndefineDirective extends PreprocessorDirective, @directive_undefine {
  /** Gets the name of the preprocessor symbol that is being unset by this directive. */
  string getName() { directive_undefines(this, result) }

  override string toString() { result = "#undef ..." }

  override string getAPrimaryQlClass() { result = "UndefineDirective" }
}
