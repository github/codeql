import semmle.code.java.Diagnostics

/*
 * This query fails if any unexpected diagnostics are recorded in the
 * database. By putting
 *    // Diagnostic Matches: PAT
 * in any source files, you can declare that diagnostics matching PAT
 * (in the string.matches(string) sense) are expected.
 */

class DiagnosticException extends Top {
  string pattern;

  DiagnosticException() {
    this.(KtComment).getText() = "// Diagnostic Matches: " + pattern
    or
    this.(Javadoc).toString() = "// Diagnostic Matches: " + pattern
  }

  Diagnostic getException() { diagnosticMessage(result).matches(pattern) }
}

string diagnosticMessage(Diagnostic d) {
  if d.getFullMessage() != "" then result = d.getFullMessage() else result = d.getMessage()
}

// Check that there aren't any old DiagnosticExceptions left after
// something is fixed.
query predicate unusedDiagnosticException(DiagnosticException de) { not exists(de.getException()) }

query predicate unexpectedDiagnostic(Compilation c, int f, int i, Diagnostic d, string s) {
  d.getCompilationInfo(c, f, i) and
  s = diagnosticMessage(d) and
  not d = any(DiagnosticException de).getException()
}
