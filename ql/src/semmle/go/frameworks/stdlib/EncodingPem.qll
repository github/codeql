/**
 * Provides classes modeling security-relevant aspects of the `encoding/pem` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/pem` package. */
module EncodingPem {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Decode(data []byte) (p *Block, rest []byte)
      hasQualifiedName("encoding/pem", "Decode") and
      (inp.isParameter(0) and outp.isResult(_))
      or
      // signature: func Encode(out io.Writer, b *Block) error
      hasQualifiedName("encoding/pem", "Encode") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func EncodeToMemory(b *Block) []byte
      hasQualifiedName("encoding/pem", "EncodeToMemory") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
