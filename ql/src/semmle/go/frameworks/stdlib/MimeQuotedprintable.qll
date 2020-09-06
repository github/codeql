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

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Reader).Read(p []byte) (n int, err error)
      this.hasQualifiedName("mime/quotedprintable", "Reader", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Writer).Write(p []byte) (n int, err error)
      this.hasQualifiedName("mime/quotedprintable", "Writer", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
