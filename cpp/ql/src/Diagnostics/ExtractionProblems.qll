/**
 * Provides a common hierarchy of all types of problems that can occur during extraction.
 */

import cpp

/*
 * A note about how the C/C++ extractor emits diagnostics:
 * When the extractor frontend encounters a problem, it emits a diagnostic message,
 * that includes a message, location and severity.
 * However, that process is best-effort and may fail (e.g. due to lack of memory).
 * Thus, if the extractor emitted at least one diagnostic of severity discretionary
 * error (or higher), it *also* emits a simple "There was an error during this compilation"
 * error diagnostic, without location information.
 * In the common case, this means that a compilation during which one or more errors happened also gets
 * the catch-all diagnostic.
 * This diagnostic has the empty string as file path.
 * We filter out these useless diagnostics if there is at least one warning-level diagnostic
 * for the affected compilation in the database.
 * Otherwise, we show it to indicate that something went wrong and that we
 * don't know what exactly happened.
 */

/**
 * A problem with a file that, if present, leads to a file being marked as non-successfully extracted.
 */
class ReportableWarning extends Diagnostic {
  ReportableWarning() {
    (
      this instanceof CompilerDiscretionaryError or
      this instanceof CompilerError or
      this instanceof CompilerCatastrophe
    ) and
    // Filter for the catch-all diagnostic, see note above.
    not this.getFile().getAbsolutePath() = ""
  }
}

private newtype TExtractionProblem =
  TReportableWarning(ReportableWarning err) or
  TCompilationFailed(Compilation c, File f) {
    f = c.getAFileCompiled() and not c.normalTermination()
  } or
  // Show the catch-all diagnostic (see note above) only if we haven't seen any other error-level diagnostic
  // for that compilation
  TUnknownProblem(CompilerError err) {
    not exists(ReportableWarning e | e.getCompilation() = err.getCompilation())
  }

/**
 * Superclass for the extraction problem hierarchy.
 */
class ExtractionProblem extends TExtractionProblem {
  /** Gets the string representation of the problem. */
  string toString() { none() }

  /** Gets the problem message for this problem. */
  string getProblemMessage() { none() }

  /** Gets the file this problem occured in. */
  File getFile() { none() }

  /** Gets the location this problem occured in. */
  Location getLocation() { none() }

  /** Gets the SARIF severity of this problem. */
  int getSeverity() { none() }
}

/**
 * An unrecoverable extraction error, where extraction was unable to finish.
 * This can be caused by a multitude of reasons, for example:
 *  - hitting a frontend assertion
 *  - crashing due to dereferencing an invalid pointer
 *  - stack overflow
 *  - out of memory
 */
class ExtractionUnrecoverableError extends ExtractionProblem, TCompilationFailed {
  Compilation c;
  File f;

  ExtractionUnrecoverableError() { this = TCompilationFailed(c, f) }

  override string toString() {
    result = "Unrecoverable extraction error while compiling " + f.toString()
  }

  override string getProblemMessage() { result = "unrecoverable compilation failure." }

  override File getFile() { result = f }

  override Location getLocation() { result = f.getLocation() }

  override int getSeverity() {
    // These extractor errors break the analysis, so we mark them in SARIF as
    // [errors](https://docs.oasis-open.org/sarif/sarif/v2.1.0/csprd01/sarif-v2.1.0-csprd01.html#_Toc10541338).
    result = 2
  }
}

/**
 * A recoverable extraction warning.
 * These are compiler errors from the frontend.
 * Upon encountering one of these, we still continue extraction, but the
 * database will be incomplete for that file.
 */
class ExtractionRecoverableWarning extends ExtractionProblem, TReportableWarning {
  ReportableWarning err;

  ExtractionRecoverableWarning() { this = TReportableWarning(err) }

  override string toString() { result = "Recoverable extraction error: " + err }

  override string getProblemMessage() { result = err.getFullMessage() }

  override File getFile() { result = err.getFile() }

  override Location getLocation() { result = err.getLocation() }

  override int getSeverity() {
    // Recoverable extraction problems don't tend to break the analysis, so we mark them in SARIF as
    // [warnings](https://docs.oasis-open.org/sarif/sarif/v2.1.0/csprd01/sarif-v2.1.0-csprd01.html#_Toc10541338).
    result = 1
  }
}

/**
 * An unknown problem happened during extraction.
 * These are only displayed if we know that we encountered an problem during extraction,
 * but, for some reason, failed to emit a proper diagnostic with location information
 * and problem message.
 */
class ExtractionUnknownProblem extends ExtractionProblem, TUnknownProblem {
  CompilerError err;

  ExtractionUnknownProblem() { this = TUnknownProblem(err) }

  override string toString() { result = "Unknown extraction problem: " + err }

  override string getProblemMessage() { result = err.getFullMessage() }

  override File getFile() { result = err.getFile() }

  override Location getLocation() { result = err.getLocation() }

  override int getSeverity() {
    // Unknown extraction problems don't tend to break the analysis, so we mark them in SARIF as
    // [warnings](https://docs.oasis-open.org/sarif/sarif/v2.1.0/csprd01/sarif-v2.1.0-csprd01.html#_Toc10541338).
    result = 1
  }
}
