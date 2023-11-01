/**
 * Provides classes modeling security-relevant aspects of the `compress/lzw` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `compress/lzw` package. */
module CompressLzw {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(w io.Writer, order Order, litWidth int) io.WriteCloser
      this.hasQualifiedName("compress/lzw", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
