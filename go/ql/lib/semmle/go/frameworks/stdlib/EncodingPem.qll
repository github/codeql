/**
 * Provides classes modeling security-relevant aspects of the `encoding/pem` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/pem` package. */
module EncodingPem {
  /** The `Encode` function in the `encoding/pem` package. */
  private class EncodeFunction extends MarshalingFunction::Range {
    EncodeFunction() { this.hasQualifiedName("encoding/pem", "Encode") }

    override FunctionInput getAnInput() { result.isParameter(1) }

    override FunctionOutput getOutput() { result.isParameter(0) }

    override string getFormat() { result = "PEM" }
  }

  /** The `EncodeToMemory` function in the `encoding/pem` package. */
  private class EncodeToMemoryFunction extends MarshalingFunction::Range {
    EncodeToMemoryFunction() { this.hasQualifiedName("encoding/pem", "EncodeToMemory") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult() }

    override string getFormat() { result = "PEM" }
  }

  /** The `Decode` function in the `encoding/pem` package. */
  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName("encoding/pem", "Decode") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "PEM" }
  }
}
