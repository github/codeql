/**
 * Provides classes modeling security-relevant aspects of the `mime/quotedprintable` package.
 */

import go

/** Provides models of commonly used functions in the `mime/quotedprintable` package. */
module MimeQuotedprintable {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(w io.Writer) *Writer
      this.hasQualifiedName("mime/quotedprintable", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
