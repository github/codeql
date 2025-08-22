/**
 * Provides classes modeling security-relevant aspects of the `compress/flate` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `compress/flate` package. */
module CompressFlate {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(w io.Writer, level int) (*Writer, error)
      this.hasQualifiedName("compress/flate", "NewWriter") and
      (inp.isResult(0) and outp.isParameter(0))
      or
      // signature: func NewWriterDict(w io.Writer, level int, dict []byte) (*Writer, error)
      this.hasQualifiedName("compress/flate", "NewWriterDict") and
      (inp.isResult(0) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
