/**
 * Provides classes modeling security-relevant aspects of the `compress/gzip` package.
 */

import go

/** Provides models of commonly used functions in the `compress/gzip` package. */
module CompressGzip {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader) (*Reader, error)
      hasQualifiedName("compress/gzip", "NewReader") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("compress/gzip", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewWriterLevel(w io.Writer, level int) (*Writer, error)
      hasQualifiedName("compress/gzip", "NewWriterLevel") and
      (inp.isResult(0) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Reader) Reset(r io.Reader) error
      hasQualifiedName("compress/gzip", "Reader", "Reset") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer) Reset(w io.Writer)
      hasQualifiedName("compress/gzip", "Writer", "Reset") and
      (inp.isReceiver() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
