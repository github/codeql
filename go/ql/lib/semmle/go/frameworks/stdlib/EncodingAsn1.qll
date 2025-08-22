/**
 * Provides classes modeling security-relevant aspects of the `encoding/asn1` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/asn1` package. */
module EncodingAsn1 {
  /** The `Marshal` or `MarshalWithParams` function in the `encoding/asn1` package. */
  private class MarshalFunction extends MarshalingFunction::Range {
    MarshalFunction() {
      this.hasQualifiedName("encoding/asn1", "Marshal") or
      this.hasQualifiedName("encoding/asn1", "MarshalWithParams")
    }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "ASN1" }
  }

  /** The `Unmarshal` or `UnmarshalWithParams` function in the `encoding/asn1` package. */
  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() {
      this.hasQualifiedName("encoding/asn1", "Unmarshal") or
      this.hasQualifiedName("encoding/asn1", "UnmarshalWithParams")
    }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "ASN1" }
  }
}
