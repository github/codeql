/**
 * @name Extraction errors
 * @description List all errors reported by the extractor or the compiler. Extractor errors are
 *              limited to those files where there are no compilation errors.
 * @kind diagnostic
 * @id cs/diagnostics/extraction-errors
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

private newtype TDiagnosticError =
  TCompilerError(CompilerError c) or
  TExtractorError(ExtractorError e)

abstract private class DiagnosticError extends TDiagnosticError {
  abstract string getMessage();

  abstract string toString();

  abstract Location getLocation();

  string getLocationMessage() {
    if this.getLocation().getFile().fromSource()
    then result = " in " + this.getLocation().getFile()
    else result = ""
  }
}

private class DiagnosticCompilerError extends DiagnosticError {
  CompilerError c;

  DiagnosticCompilerError() { this = TCompilerError(c) }

  override string getMessage() {
    result = "Compiler error" + this.getLocationMessage() + ": " + c.getMessage()
  }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }
}

private class DiagnosticExtractorError extends DiagnosticError {
  ExtractorError e;

  DiagnosticExtractorError() {
    this = TExtractorError(e) and
    not exists(CompilerError ce | ce.getLocation().getFile() = e.getLocation().getFile())
  }

  override string getMessage() {
    result =
      "Unexpected " + e.getOrigin() + " error" + this.getLocationMessage() + ": " + e.getText()
  }

  override string toString() { result = e.toString() }

  override Location getLocation() { result = e.getLocation() }
}

from DiagnosticError error
select error.getMessage(), 2
