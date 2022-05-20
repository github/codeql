/**
 * Provides classes modeling security-relevant aspects of the `compress/zlib` package.
 */

import go

/** Provides models of commonly used functions in the `compress/zlib` package. */
module CompressZlib {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader) (io.ReadCloser, error)
      hasQualifiedName("compress/zlib", "NewReader") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewReaderDict(r io.Reader, dict []byte) (io.ReadCloser, error)
      hasQualifiedName("compress/zlib", "NewReaderDict") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("compress/zlib", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewWriterLevel(w io.Writer, level int) (*Writer, error)
      hasQualifiedName("compress/zlib", "NewWriterLevel") and
      (inp.isResult(0) and outp.isParameter(0))
      or
      // signature: func NewWriterLevelDict(w io.Writer, level int, dict []byte) (*Writer, error)
      hasQualifiedName("compress/zlib", "NewWriterLevelDict") and
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
      // signature: func (*Writer) Reset(w io.Writer)
      hasQualifiedName("compress/zlib", "Writer", "Reset") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (Resetter) Reset(r io.Reader, dict []byte) error
      implements("compress/zlib", "Resetter", "Reset") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
