/**
 * Provides classes and predicates for reporting extractor diagnostics to end users.
 */

import java
import semmle.code.java.Diagnostics

/** Gets the SARIF severity level that indicates an error. */
private int getErrorSeverity() { result = 2 }

/** Gets the SARIF severity level that indicates a warning. */
private int getWarnSeverity() { result = 1 }

private predicate knownWarnings(Diagnostic d, string msg, int sev) {
  exists(string filename |
    d.getSeverity() = 2 and
    d.getMessage() = "Skipping Lombok-ed source file: " + filename and
    msg = "Use of Lombok detected. Skipping file: " + filename and
    sev = getWarnSeverity()
  )
}

private predicate knownErrors(Diagnostic d, string msg, int sev) {
  exists(string numErr, Location l |
    d.getSeverity() = 6 and
    d.getMessage() = numErr and
    d.getLocation() = l and
    msg = "Frontend errors in file: " + l.getFile().getAbsolutePath() + " (" + numErr + ")" and
    sev = getErrorSeverity()
  )
  or
  exists(string filename |
    d.getSeverity() = 7 and
    d.getMessage() = "Exception compiling file " + filename and
    msg = "Extraction incomplete in file: " + filename and
    sev = getErrorSeverity()
  )
  or
  exists(string errMsg |
    d.getSeverity() = 8 and
    d.getMessage() = errMsg and
    msg = "Severe error: " + errMsg and
    sev = getErrorSeverity()
  )
}

private predicate unknownErrors(Diagnostic d, string msg, int sev) {
  not knownErrors(d, _, _) and
  exists(File f, int diagSev |
    d.getSeverity() = diagSev and
    d.getLocation().getFile() = f and
    diagSev > 3
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
predicate reportableDiagnostics(Diagnostic d, string msg, int sev) {
  reportableWarnings(d, msg, sev) or reportableErrors(d, msg, sev)
}

/**
 * Holds if an extraction error occurred that should be reported to end users,
 * with the message `msg` and SARIF severity `sev`.
 */
predicate reportableErrors(Diagnostic d, string msg, int sev) {
  knownErrors(d, msg, sev) or unknownErrors(d, msg, sev)
}

/**
 * Holds if an extraction warning occurred that should be reported to end users,
 * with the message `msg` and SARIF severity `sev`.
 */
predicate reportableWarnings(Diagnostic d, string msg, int sev) { knownWarnings(d, msg, sev) }

/**
 * Holds if compilation unit `f` is a source file.
 */
predicate extracted(CompilationUnit f) { exists(f.getRelativePath()) and f.fromSource() }

/**
 * Holds if compilation unit `f` is a source file that has
 * no relevant extraction diagnostics associated with it.
 */
predicate successfullyExtracted(CompilationUnit f) {
  extracted(f) and
  not exists(Diagnostic d | reportableDiagnostics(d, _, _) and d.getLocation().getFile() = f)
}
