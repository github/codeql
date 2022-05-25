/**
 * Provides classes modeling security-relevant aspects of the `encoding/pem` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/pem` package. */
module EncodingPem {
  /** The `Encode` function in the `encoding/pem` package. */
  private class EncodeFunction extends MarshalingFunction::Range {
    EncodeFunction() { hasQualifiedName("encoding/pem", "Encode") }

    override FunctionInput getAnInput() { result.isParameter(1) }

    override FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "PEM" }
  }

  /** The `EncodeToMemory` function in the `encoding/pem` package. */
  private class EncodeToMemoryFunction extends MarshalingFunction::Range {
    EncodeToMemoryFunction() { hasQualifiedName("encoding/pem", "EncodeToMemory") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult() }

    override string getFormat() { result = "PEM" }
  }

  /** The `Decode` function in the `encoding/pem` package. */
  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() { hasQualifiedName("encoding/pem", "Decode") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "PEM" }
  }

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
