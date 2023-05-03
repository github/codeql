/**
 * Provides classes modeling security-relevant aspects of the `compress/gzip` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `compress/gzip` package. */
module CompressGzip {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(w io.Writer) *Writer
      this.hasQualifiedName("compress/gzip", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewWriterLevel(w io.Writer, level int) (*Writer, error)
      this.hasQualifiedName("compress/gzip", "NewWriterLevel") and
      (inp.isResult(0) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
