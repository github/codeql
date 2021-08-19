/**
 * Provides classes modeling security-relevant aspects of the `encoding` package.
 */

import go

/** Provides models of commonly used functions in the `encoding` package. */
module Encoding {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (BinaryMarshaler) MarshalBinary() (data []byte, err error)
      implements("encoding", "BinaryMarshaler", "MarshalBinary") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (TextMarshaler) MarshalText() (text []byte, err error)
      implements("encoding", "TextMarshaler", "MarshalText") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (BinaryUnmarshaler) UnmarshalBinary(data []byte) error
      implements("encoding", "BinaryUnmarshaler", "UnmarshalBinary") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (TextUnmarshaler) UnmarshalText(text []byte) error
      implements("encoding", "TextUnmarshaler", "UnmarshalText") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
