/**
 * Provides classes modeling security-relevant aspects of the `encoding/xml` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/xml` package. */
module EncodingXml {
  /** The `Marshal` or `MarshalIndent` function in the `encoding/xml` package. */
  private class MarshalFunction extends MarshalingFunction::Range {
    MarshalFunction() {
      this.hasQualifiedName("encoding/xml", "Marshal") or
      this.hasQualifiedName("encoding/xml", "MarshalIndent")
    }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "XML" }
  }

  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName("encoding/xml", "Unmarshal") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "XML" }
  }
}
