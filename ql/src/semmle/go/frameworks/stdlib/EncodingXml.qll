/**
 * Provides classes modeling security-relevant aspects of the `encoding/xml` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/xml` package. */
module EncodingXml {
  /** The `Marshal` or `MarshalIndent` function in the `encoding/xml` package. */
  private class MarshalFunction extends MarshalingFunction::Range {
    MarshalFunction() {
      hasQualifiedName("encoding/xml", "Marshal") or
      hasQualifiedName("encoding/xml", "MarshalIndent")
    }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isResult(0) }

    override string getFormat() { result = "XML" }
  }

  private class UnmarshalFunction extends UnmarshalingFunction::Range {
    UnmarshalFunction() { hasQualifiedName("encoding/xml", "Unmarshal") }

    override FunctionInput getAnInput() { result.isParameter(0) }

    override FunctionOutput getOutput() { result.isParameter(1) }

    override string getFormat() { result = "XML" }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func CopyToken(t Token) Token
      hasQualifiedName("encoding/xml", "CopyToken") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Escape(w io.Writer, s []byte)
      hasQualifiedName("encoding/xml", "Escape") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func EscapeText(w io.Writer, s []byte) error
      hasQualifiedName("encoding/xml", "EscapeText") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func Marshal(v interface{}) ([]byte, error)
      hasQualifiedName("encoding/xml", "Marshal") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func MarshalIndent(v interface{}, prefix string, indent string) ([]byte, error)
      hasQualifiedName("encoding/xml", "MarshalIndent") and
      (inp.isParameter(_) and outp.isResult(0))
      or
      // signature: func NewDecoder(r io.Reader) *Decoder
      hasQualifiedName("encoding/xml", "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewEncoder(w io.Writer) *Encoder
      hasQualifiedName("encoding/xml", "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewTokenDecoder(t TokenReader) *Decoder
      hasQualifiedName("encoding/xml", "NewTokenDecoder") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Unmarshal(data []byte, v interface{}) error
      hasQualifiedName("encoding/xml", "Unmarshal") and
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
      // signature: func (CharData).Copy() CharData
      hasQualifiedName("encoding/xml", "CharData", "Copy") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Comment).Copy() Comment
      hasQualifiedName("encoding/xml", "Comment", "Copy") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Decoder).Decode(v interface{}) error
      hasQualifiedName("encoding/xml", "Decoder", "Decode") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Decoder).DecodeElement(v interface{}, start *StartElement) error
      hasQualifiedName("encoding/xml", "Decoder", "DecodeElement") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Decoder).RawToken() (Token, error)
      hasQualifiedName("encoding/xml", "Decoder", "RawToken") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Decoder).Token() (Token, error)
      hasQualifiedName("encoding/xml", "Decoder", "Token") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (Directive).Copy() Directive
      hasQualifiedName("encoding/xml", "Directive", "Copy") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Encoder).Encode(v interface{}) error
      hasQualifiedName("encoding/xml", "Encoder", "Encode") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Encoder).EncodeElement(v interface{}, start StartElement) error
      hasQualifiedName("encoding/xml", "Encoder", "EncodeElement") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Encoder).EncodeToken(t Token) error
      hasQualifiedName("encoding/xml", "Encoder", "EncodeToken") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Encoder).Indent(prefix string, indent string)
      hasQualifiedName("encoding/xml", "Encoder", "Indent") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (ProcInst).Copy() ProcInst
      hasQualifiedName("encoding/xml", "ProcInst", "Copy") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (StartElement).Copy() StartElement
      hasQualifiedName("encoding/xml", "StartElement", "Copy") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Marshaler).MarshalXML(e *Encoder, start StartElement) error
      this.implements("encoding/xml", "Marshaler", "MarshalXML") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (TokenReader).Token() (Token, error)
      this.implements("encoding/xml", "TokenReader", "Token") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (Unmarshaler).UnmarshalXML(d *Decoder, start StartElement) error
      this.implements("encoding/xml", "Unmarshaler", "UnmarshalXML") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
