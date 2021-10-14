/**
 * Provides classes modeling security-relevant aspects of the `encoding/base64` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/base64` package. */
module EncodingBase64 {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewDecoder(enc *Encoding, r io.Reader) io.Reader
      hasQualifiedName("encoding/base64", "NewDecoder") and
      (inp.isParameter(1) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Encoding) Decode(dst []byte, src []byte) (n int, err error)
      hasQualifiedName("encoding/base64", "Encoding", "Decode") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func (*Encoding) DecodeString(s string) ([]byte, error)
      hasQualifiedName("encoding/base64", "Encoding", "DecodeString") and
      (inp.isParameter(0) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
