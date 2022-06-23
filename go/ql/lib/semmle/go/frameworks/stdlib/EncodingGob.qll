/**
 * Provides classes modeling security-relevant aspects of the `encoding/gob` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/gob` package. */
module EncodingGob {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewDecoder(r io.Reader) *Decoder
      hasQualifiedName("encoding/gob", "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewEncoder(w io.Writer) *Encoder
      hasQualifiedName("encoding/gob", "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Decoder) Decode(e interface{}) error
      hasQualifiedName("encoding/gob", "Decoder", "Decode") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Decoder) DecodeValue(v reflect.Value) error
      hasQualifiedName("encoding/gob", "Decoder", "DecodeValue") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Encoder) Encode(e interface{}) error
      hasQualifiedName("encoding/gob", "Encoder", "Encode") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Encoder) EncodeValue(value reflect.Value) error
      hasQualifiedName("encoding/gob", "Encoder", "EncodeValue") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (GobDecoder) GobDecode([]byte) error
      implements("encoding/gob", "GobDecoder", "GobDecode") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (GobEncoder) GobEncode() ([]byte, error)
      implements("encoding/gob", "GobEncoder", "GobEncode") and
      (inp.isReceiver() and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
