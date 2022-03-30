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
      // signature: func NewReader(r io.Reader) *Reader
      hasQualifiedName("mime/quotedprintable", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("mime/quotedprintable", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
