/**
 * Provides classes modeling security-relevant aspects of the `encoding/gob` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `encoding/gob` package. */
module EncodingGob {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewEncoder(w io.Writer) *Encoder
      this.hasQualifiedName("encoding/gob", "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
