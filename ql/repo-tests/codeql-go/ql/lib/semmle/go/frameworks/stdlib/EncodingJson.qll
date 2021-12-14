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

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Compact(dst *bytes.Buffer, src []byte) error
      this.hasQualifiedName("encoding/json", "Compact") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func HTMLEscape(dst *bytes.Buffer, src []byte)
      this.hasQualifiedName("encoding/json", "HTMLEscape") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func Indent(dst *bytes.Buffer, src []byte, prefix string, indent string) error
      this.hasQualifiedName("encoding/json", "Indent") and
      (inp.isParameter([1, 2, 3]) and outp.isParameter(0))
      or
      // signature: func Marshal(v interface{}) ([]byte, error)
      this.hasQualifiedName("encoding/json", "Marshal") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func MarshalIndent(v interface{}, prefix string, indent string) ([]byte, error)
      this.hasQualifiedName("encoding/json", "MarshalIndent") and
      (inp.isParameter(_) and outp.isResult(0))
      or
      // signature: func NewDecoder(r io.Reader) *Decoder
      this.hasQualifiedName("encoding/json", "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewEncoder(w io.Writer) *Encoder
      this.hasQualifiedName("encoding/json", "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func Unmarshal(data []byte, v interface{}) error
      this.hasQualifiedName("encoding/json", "Unmarshal") and
      (inp.isParameter(0) and outp.isParameter(1))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Decoder) Buffered() io.Reader
      this.hasQualifiedName("encoding/json", "Decoder", "Buffered") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Decoder) Decode(v interface{}) error
      this.hasQualifiedName("encoding/json", "Decoder", "Decode") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Decoder) Token() (Token, error)
      this.hasQualifiedName("encoding/json", "Decoder", "Token") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Encoder) Encode(v interface{}) error
      this.hasQualifiedName("encoding/json", "Encoder", "Encode") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Encoder) SetIndent(prefix string, indent string)
      this.hasQualifiedName("encoding/json", "Encoder", "SetIndent") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (Marshaler) MarshalJSON() ([]byte, error)
      this.implements("encoding/json", "Marshaler", "MarshalJSON") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (Unmarshaler) UnmarshalJSON([]byte) error
      this.implements("encoding/json", "Unmarshaler", "UnmarshalJSON") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
