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
  string getMessage() { none() }

  string toString() { none() }

  string getLocation(Location l) {
    if l.getFile().fromSource() then result = " in " + l.getFile() else result = ""
  }
}

private class DiagnosticCompilerError extends DiagnosticError {
  CompilerError c;

  DiagnosticCompilerError() { this = TCompilerError(c) }

  override string getMessage() {
    result = "Compiler error" + getLocation(c.getLocation()) + ": " + c.getMessage()
  }

  override string toString() { result = c.toString() }
}

private class DiagnosticExtractorError extends DiagnosticError {
  ExtractorError e;

  DiagnosticExtractorError() {
    this = TExtractorError(e) and
    not exists(CompilerError ce | ce.getLocation().getFile() = e.getLocation().getFile())
  }

  override string getMessage() {
    result =
      "Unexpected " + e.getOrigin() + " error" + getLocation(e.getLocation()) + ": " + e.getText()
  }

  override string toString() { result = e.toString() }
}

from DiagnosticError error
select error.getMessage(), 3
