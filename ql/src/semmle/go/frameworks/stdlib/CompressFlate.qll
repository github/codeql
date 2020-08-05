/**
 * Provides classes modeling security-relevant aspects of the `compress/flate` package.
 */

import go

/** Provides models of commonly used functions in the `compress/flate` package. */
module CompressFlate {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader) io.ReadCloser
      hasQualifiedName("compress/flate", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewReaderDict(r io.Reader, dict []byte) io.ReadCloser
      hasQualifiedName("compress/flate", "NewReaderDict") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer, level int) (*Writer, error)
      hasQualifiedName("compress/flate", "NewWriter") and
      (inp.isResult(0) and outp.isParameter(0))
      or
      // signature: func NewWriterDict(w io.Writer, level int, dict []byte) (*Writer, error)
      hasQualifiedName("compress/flate", "NewWriterDict") and
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
      // signature: func (*Writer).Reset(dst io.Writer)
      this.hasQualifiedName("compress/flate", "Writer", "Reset") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Writer).Write(data []byte) (n int, err error)
      this.hasQualifiedName("compress/flate", "Writer", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Resetter).Reset(r io.Reader, dict []byte) error
      this.implements("compress/flate", "Resetter", "Reset") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
