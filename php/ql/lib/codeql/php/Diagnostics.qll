/**
 * Provides utilities for reporting errors and diagnostics in the PHP extractor.
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * Holds if program p had extraction errors.
 */
predicate isErrorProgram(TS::PHP::Program p) {
  // Currently no extraction errors are tracked in the database
  // This will be populated by the extractor when errors occur
  none()
}

/**
 * Holds if program p was successfully extracted.
 */
predicate isSuccessfulProgram(TS::PHP::Program p) {
  not isErrorProgram(p)
}

/**
 * Gets all programs with extraction errors.
 */
TS::PHP::Program getErrorProgram() {
  isErrorProgram(result)
}
