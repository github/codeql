/**
 * Provides classes modeling security-relevant aspects of the `encoding/binary` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/binary` package. */
module EncodingBinary {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Read(r io.Reader, order ByteOrder, data interface{}) error
      hasQualifiedName("encoding/binary", "Read") and
      (inp.isParameter(0) and outp.isParameter(2))
      or
      // signature: func Write(w io.Writer, order ByteOrder, data interface{}) error
      hasQualifiedName("encoding/binary", "Write") and
      (inp.isParameter(2) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
