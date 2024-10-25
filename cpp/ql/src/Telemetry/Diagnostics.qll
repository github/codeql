import cpp

/**
 * A syntax error.
 */
class SyntaxError extends CompilerError {
  SyntaxError() { this.getTag().matches("exp_%") }
}

/**
 * A cannot open file error.
 * Typically this is due to a missing include.
 */
class CannotOpenFile extends CompilerError {
  CannotOpenFile() { this.hasTag("cannot_open_file") }

  string getIncludedFile() {
    result = this.getMessage().regexpCapture("cannot open source file '([^']+)'", 1)
  }
}

/**
 * An undefined identifier error.
 * Currently unused.
 */
class UndefinedIdentifier extends CompilerError {
  UndefinedIdentifier() { this.hasTag("undefined_identifier") }

  string getIdentifier() {
    result = this.getMessage().regexpCapture("identifier '([^']+)' is undefined", 1)
  }
}
