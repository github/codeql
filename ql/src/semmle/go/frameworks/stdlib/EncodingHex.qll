/**
 * Provides classes modeling security-relevant aspects of the `encoding/hex` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/hex` package. */
module EncodingHex {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Decode(dst []byte, src []byte) (int, error)
      hasQualifiedName("encoding/hex", "Decode") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func DecodeString(s string) ([]byte, error)
      hasQualifiedName("encoding/hex", "DecodeString") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func Dump(data []byte) string
      hasQualifiedName("encoding/hex", "Dump") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Dumper(w io.Writer) io.WriteCloser
      hasQualifiedName("encoding/hex", "Dumper") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func Encode(dst []byte, src []byte) int
      hasQualifiedName("encoding/hex", "Encode") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func EncodeToString(src []byte) string
      hasQualifiedName("encoding/hex", "EncodeToString") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewDecoder(r io.Reader) io.Reader
      hasQualifiedName("encoding/hex", "NewDecoder") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewEncoder(w io.Writer) io.Writer
      hasQualifiedName("encoding/hex", "NewEncoder") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
