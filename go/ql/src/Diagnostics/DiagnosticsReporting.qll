import go

/** Gets the SARIF severity level that indicates an error. */
private int getErrorSeverity() { result = 2 }

private class Diagnostic extends @diagnostic {
  /**
   * Gets the kind of error. This can be:
   * * `@unknownerror`: an unknown error
   * * `@listerror`: an error from the frontend
   * * `@parseerror`: a parse error
   * * `@typeerror`: a type error
   */
  string getKind() { diagnostics(this, _, result, _, _, _) }

  /** Gets the error message for this error. */
  string getMessage() { diagnostics(this, _, _, result, _, _) }

  /** Gets the file that this error is associated with, if any. */
  File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(Location l | diagnostics(this, _, _, _, _, l) | l.hasLocationInfo(path, sl, sc, el, ec))
  }

  string toString() { result = this.getMessage() }
}

/**
 * Holds if an extraction error or warning occurred that should be reported to end users,
 * with the error message `msg` and SARIF severity `sev`.
 */
predicate reportableDiagnostics(Diagnostic d, string msg, int sev) {
  // Go does not have warnings, so all errors have error severity
  sev = getErrorSeverity() and
  (
    // Only report errors for files that would have been extracted
    exists(File f | f = d.getFile() |
      exists(f.getAChild()) and
      msg =
        "Extraction failed in " + d.getFile().getRelativePath() + " with error " + d.getMessage()
    )
    or
    not exists(d.getFile()) and
    msg = "Extraction failed with error " + d.getMessage()
  )
}
