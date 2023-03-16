/**
 * Provides classes modeling security-relevant aspects of the `encoding/json` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/json` package. */
module EncodingJson {
  private class Escape extends EscapeFunction::Range {
    Escape() { this.hasQualifiedName("encoding/json", "HTMLEscape") }

    override string kind() { result = "html" }
  }

  /** The `Marshal` or `MarshalIndent` function in the `encoding/json` package. */
  class MarshalFunction extends MarshalingFunction::Range {
    MarshalFunction() { this.hasQualifiedName("encoding/json", ["Marshal", "MarshalIndent"]) }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "JSON" }
  }

  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() { this.hasQualifiedName("encoding/json", "Unmarshal") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "JSON" }
  }
}
