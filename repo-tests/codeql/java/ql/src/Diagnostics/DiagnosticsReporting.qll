/**
 * Provides classes and predicates for reporting extractor diagnostics to end users.
 */

import java

/** Gets the SARIF severity level that indicates an error. */
private int getErrorSeverity() { result = 2 }

/** Gets the SARIF severity level that indicates a warning. */
private int getWarnSeverity() { result = 1 }

private predicate knownWarnings(@diagnostic d, string msg, int sev) {
  exists(string filename |
    diagnostics(d, 2, _, "Skipping Lombok-ed source file: " + filename, _, _) and
    msg = "Use of Lombok detected. Skipping file: " + filename and
    sev = getWarnSeverity()
  )
}

private predicate knownErrors(@diagnostic d, string msg, int sev) {
  exists(string numErr, Location l |
    diagnostics(d, 6, _, numErr, _, l) and
    msg = "Frontend errors in file: " + l.getFile().getAbsolutePath() + " (" + numErr + ")" and
    sev = getErrorSeverity()
  )
  or
  exists(string filename, Location l |
    diagnostics(d, 7, _, "Exception compiling file " + filename, _, l) and
    msg = "Extraction incomplete in file: " + filename and
    sev = getErrorSeverity()
  )
  or
  exists(string errMsg, Location l |
    diagnostics(d, 8, _, errMsg, _, l) and
    msg = "Severe error: " + errMsg and
    sev = getErrorSeverity()
  )
}

private predicate unknownErrors(@diagnostic d, string msg, int sev) {
  not knownErrors(d, _, _) and
  exists(Location l, File f, int diagSev |
    diagnostics(d, diagSev, _, _, _, l) and l.getFile() = f and diagSev > 3
  |
    exists(f.getRelativePath()) and
    msg = "Unknown errors in file: " + f.getAbsolutePath() + " (" + diagSev + ")" and
    sev = getErrorSeverity()
  )
}

/**
 * Holds if an extraction error or warning occurred that should be reported to end users,
 * with the message `msg` and SARIF severity `sev`.
 */
predicate reportableDiagnostics(@diagnostic d, string msg, int sev) {
  reportableWarnings(d, msg, sev) or reportableErrors(d, msg, sev)
}

/**
 * Holds if an extraction error occurred that should be reported to end users,
 * with the message `msg` and SARIF severity `sev`.
 */
predicate reportableErrors(@diagnostic d, string msg, int sev) {
  knownErrors(d, msg, sev) or unknownErrors(d, msg, sev)
}

/**
 * Holds if an extraction warning occurred that should be reported to end users,
 * with the message `msg` and SARIF severity `sev`.
 */
predicate reportableWarnings(@diagnostic d, string msg, int sev) { knownWarnings(d, msg, sev) }

/**
 * Holds if compilation unit `f` is a source file that has
 * no relevant extraction diagnostics associated with it.
 */
predicate successfullyExtracted(CompilationUnit f) {
  not exists(@diagnostic d, Location l |
    reportableDiagnostics(d, _, _) and diagnostics(d, _, _, _, _, l) and l.getFile() = f
  ) and
  exists(f.getRelativePath()) and
  f.fromSource()
}
