/**
 * Provides classes modeling security-relevant aspects of the `compress/zlib` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `compress/zlib` package. */
module CompressZlib {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
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
}
