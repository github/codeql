/**
 * Provides classes modeling security-relevant aspects of the `html` package.
 */

import go

/** Provides models of commonly used functions in the `html` package. */
module Html {
  private class Escape extends EscapeFunction::Range {
    Escape() { hasQualifiedName("html", "EscapeString") }

    override string kind() { result = "html" }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func EscapeString(s string) string
      hasQualifiedName("html", "EscapeString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func UnescapeString(s string) string
      hasQualifiedName("html", "UnescapeString") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
