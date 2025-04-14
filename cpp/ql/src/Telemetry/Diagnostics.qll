import cpp

/**
 * A syntax error.
 */
class SyntaxError extends CompilerError {
  SyntaxError() {
    this.getTag().matches("exp_%") or
    this.getTag() =
      [
        "bad_data_member_initialization", "bad_pure_specifier", "bad_return", "bad_uuid_string",
        "literal_without_initializer", "missing_class_definition", "missing_exception_declaration",
        "nonstd_const_member_decl_not_allowed", "operator_name_not_allowed",
        "wide_string_invalid_in_asm"
      ]
  }
}

/**
 * A cannot open file error.
 * Typically this is due to a missing include.
 */
class CannotOpenFileError extends CompilerError {
  CannotOpenFileError() { this.hasTag(["cannot_open_file", "cannot_open_file_reason"]) }

  string getIncludedFile() {
    result = this.getMessage().regexpCapture("cannot open source file '([^']+)'", 1)
  }
}
