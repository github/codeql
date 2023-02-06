/**
 * Provides classes modeling security-relevant aspects of the `mime` package.
 */

import go

/** Provides models of commonly used functions in the `mime` package. */
module Mime {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func FormatMediaType(t string, param map[string]string) string
      hasQualifiedName("mime", "FormatMediaType") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func ParseMediaType(v string) (mediatype string, params map[string]string, err error)
      hasQualifiedName("mime", "ParseMediaType") and
      (inp.isParameter(0) and outp.isResult([0, 1]))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*WordDecoder) Decode(word string) (string, error)
      hasQualifiedName("mime", "WordDecoder", "Decode") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func (*WordDecoder) DecodeHeader(header string) (string, error)
      hasQualifiedName("mime", "WordDecoder", "DecodeHeader") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func (WordEncoder) Encode(charset string, s string) string
      hasQualifiedName("mime", "WordEncoder", "Encode") and
      (inp.isParameter(1) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
