/** Provides classes for working with errors and warnings recorded during extraction. */

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
  File getFile() { result = this.getLocation().getFile() }

  /** Gets the location for this error. */
  Location getLocation() { diagnostics(this, _, _, _, _, result) }

  string toString() { result = this.getMessage() }
}

bindingset[msg]
private string removeAbsolutePaths(string msg) {
  exists(string r |
    // turn both
    // cannot find package "subdir1/subsubdir1" in any of:\n\t/usr/local/Cellar/go/1.20.5/libexec/src/subdir1/subsubdir1 (from $GOROOT)\n\t/Users/owen-mc/go/src/subdir1/subsubdir1 (from $GOPATH)
    // and
    // cannot find package "subdir1/subsubdir1" in any of:\n\tC:\\hostedtoolcache\\windows\\go\\1.20.5\\x64\\src\\subdir1\\subsubdir1 (from $GOROOT)\n\tC:\\Users\\runneradmin\\go\\src\\subdir1\\subsubdir1 (from $GOPATH)
    // into
    // cannot find package "subdir1/subsubdir1" in any of:\n\t(absolute path) (from $GOROOT)\n\t(absolute path) (from $GOPATH)
    r =
      "(cannot find package [^ ]* in any of:\\n\\t).*( \\(from \\$GOROOT\\)\\n\\t).*( \\(from \\$GOPATH\\))" and
    if exists(msg.regexpCapture(r, 1))
    then
      result =
        msg.regexpCapture(r, 1) + "(absolute path)" + msg.regexpCapture(r, 2) + "(absolute path)" +
          msg.regexpCapture(r, 3)
    else result = msg
  )
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
        "Extraction failed in " + f.getRelativePath() + " with error " +
          removeAbsolutePaths(d.getMessage())
    )
    or
    not exists(d.getFile()) and
    msg = "Extraction failed with error " + removeAbsolutePaths(d.getMessage())
  )
}
