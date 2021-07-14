/**
 * Provides a common hierarchy of all types of errors that can occur during extraction.
 */

import cpp

/*
 * A note about how the C/C++ extractor emits diagnostics:
 * When the extractor frontend encounters an error, it emits a diagnostic message,
 * that includes a message, location and severity.
 * However, that process is best-effort and may fail (e.g. due to lack of memory).
 * Thus, if the extractor emitted at least one diagnostic of severity discretionary
 * error (or higher), it *also* emits a simple "There was an error during this compilation"
 * error diagnostic, without location information.
 * In the common case, this means that a compilation during which one or more errors happened also gets
 * the catch-all diagnostic.
 * This diagnostic has the empty string as file path.
 * We filter out these useless diagnostics if there is at least one error-level diagnostic
 * for the affected compilation in the database.
 * Otherwise, we show it to indicate that something went wrong and that we
 * don't know what exactly happened.
 */

/**
 * An error that, if present, leads to a file being marked as non-successfully extracted.
 */
class ReportableError extends Diagnostic {
  ReportableError() {
    (
      this instanceof CompilerDiscretionaryError or
      this instanceof CompilerError or
      this instanceof CompilerCatastrophe
    ) and
    // Filter for the catch-all diagnostic, see note above.
    not this.getFile().getAbsolutePath() = ""
  }
}

private newtype TExtractionError =
  TReportableError(ReportableError err) or
  TCompilationFailed(Compilation c, File f) {
    f = c.getAFileCompiled() and not c.normalTermination()
  } or
  // Show the catch-all diagnostic (see note above) only if we haven't seen any other error-level diagnostic
  // for that compilation
  TUnknownError(CompilerError err) {
    not exists(ReportableError e | e.getCompilation() = err.getCompilation())
  }

/**
 * Superclass for the extraction error hierarchy.
 */
class ExtractionError extends TExtractionError {
  /** Gets the string representation of the error. */
  string toString() { none() }

  /** Gets the error message for this error. */
  string getErrorMessage() { none() }

  /** Gets the file this error occured in. */
  File getFile() { none() }

  /** Gets the location this error occured in. */
  Location getLocation() { none() }

  /** Gets the SARIF severity of this error. */
  int getSeverity() {
    // Unfortunately, we can't distinguish between errors and fatal errors in SARIF,
    // so all errors have severity 2.
    result = 2
  }
}

/**
 * An unrecoverable extraction error, where extraction was unable to finish.
 * This can be caused by a multitude of reasons, for example:
 *  - hitting a frontend assertion
 *  - crashing due to dereferencing an invalid pointer
 *  - stack overflow
 *  - out of memory
 */
class ExtractionUnrecoverableError extends ExtractionError, TCompilationFailed {
  Compilation c;
  File f;

  ExtractionUnrecoverableError() { this = TCompilationFailed(c, f) }

  override string toString() {
    result = "Unrecoverable extraction error while compiling " + f.toString()
  }

  override string getErrorMessage() { result = "unrecoverable compilation failure." }

  override File getFile() { result = f }

  override Location getLocation() { result = f.getLocation() }
}

/**
 * A recoverable extraction error.
 * These are compiler errors from the frontend.
 * Upon encountering one of these, we still continue extraction, but the
 * database will be incomplete for that file.
 */
class ExtractionRecoverableError extends ExtractionError, TReportableError {
  ReportableError err;

  ExtractionRecoverableError() { this = TReportableError(err) }

  override string toString() { result = "Recoverable extraction error: " + err }

  override string getErrorMessage() { result = err.getFullMessage() }

  override File getFile() { result = err.getFile() }

  override Location getLocation() { result = err.getLocation() }
}

/**
 * An unknown error happened during extraction.
 * These are only displayed if we know that we encountered an error during extraction,
 * but, for some reason, failed to emit a proper diagnostic with location information
 * and error message.
 */
class ExtractionUnknownError extends ExtractionError, TUnknownError {
  CompilerError err;

  ExtractionUnknownError() { this = TUnknownError(err) }

  override string toString() { result = "Unknown extraction error: " + err }

  override string getErrorMessage() { result = err.getFullMessage() }

  override File getFile() { result = err.getFile() }

  override Location getLocation() { result = err.getLocation() }
}
