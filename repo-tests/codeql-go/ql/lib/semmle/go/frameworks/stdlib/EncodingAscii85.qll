/**
 * Provides classes modeling security-relevant aspects of the `encoding/ascii85` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/ascii85` package. */
module EncodingAscii85 {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Decode(dst []byte, src []byte, flush bool) (ndst int, nsrc int, err error)
      hasQualifiedName("encoding/ascii85", "Decode") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func NewDecoder(r io.Reader) io.Reader
      hasQualifiedName("encoding/ascii85", "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
