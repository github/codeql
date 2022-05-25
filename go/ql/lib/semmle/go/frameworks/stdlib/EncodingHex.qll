/**
 * Provides classes modeling security-relevant aspects of the `encoding/hex` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/hex` package. */
module EncodingHex {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Decode(dst []byte, src []byte) (int, error)
      hasQualifiedName("encoding/hex", "Decode") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func DecodeString(s string) ([]byte, error)
      hasQualifiedName("encoding/hex", "DecodeString") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewDecoder(r io.Reader) io.Reader
      hasQualifiedName("encoding/hex", "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
