/**
 * Provides classes modeling security-relevant aspects of the `compress/bzip2` package.
 */

import go

/** Provides models of commonly used functions in the `compress/bzip2` package. */
module CompressBzip2 {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader) io.Reader
      hasQualifiedName("compress/bzip2", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
