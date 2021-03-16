import cpp

/**
 * The class of errors upon we mark a file as non-successfully extracted.
 */
class ReportableError extends Diagnostic {
  ReportableError() {
    (
      this instanceof CompilerDiscretionaryError or
      this instanceof CompilerError or
      this instanceof CompilerCatastrophe
    ) and
    // If the extractor encounters an error in a compilation, it always emits a
    // catch-all diagnostic "There was an error during this compilation", to ensure
    // that the error makes it to the database.
    // This error doesn't have a file path attached to it, and is thus
    // useless for us to report. Furthermore, in the common case, we will have a
    // proper diagnostic for this error we can show.
    // Instead, we synthesize `TUnknownError` if this is the only error that we can show to the user.
    not this.getFile().getAbsolutePath() = ""
  }
}

private newtype TExtractionError =
  TReportableError(ReportableError err) or
  TCompilationFailed(Compilation c, File f) {
    f = c.getAFileCompiled() and not c.normalTermination()
  } or
  // Report generic extractor errors only if we haven't seen any other error-level diagnostic
  TUnknownError(CompilerError err) { not exists(ReportableError e) }

/**
 * Superclass for the extraction error hierarchy.
 */
class ExtractionError extends TExtractionError {
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
 * An irrecoverable extraction failure, where extraction was unable to finish.
 * This can be caused by a multitude of reasons, for example:
 *  - hitting a frontend assertion
 *  - crashing due to dereferencing an invalid pointer
 *  - stack overflow
 *  - out of memory
 */
class ExtractionIrrecoverableError extends ExtractionError, TCompilationFailed {
  Compilation c;
  File f;

  ExtractionIrrecoverableError() { this = TCompilationFailed(c, f) }

  override string toString() {
    result = "Irrecoverable extraction error while compiling " + f.toString()
  }

  override string getErrorMessage() {
    result =
      "Irrecoverable compilation failure, check logs/build-tracer.log in the database directory for more information."
  }

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
