/**
 * Provides classes modeling security-relevant aspects of the `compress/lzw` package.
 */

import go

/** Provides models of commonly used functions in the `compress/lzw` package. */
module CompressLzw {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader, order Order, litWidth int) io.ReadCloser
      hasQualifiedName("compress/lzw", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer, order Order, litWidth int) io.WriteCloser
      hasQualifiedName("compress/lzw", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
