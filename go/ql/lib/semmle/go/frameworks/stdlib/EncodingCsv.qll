/**
 * Provides classes modeling security-relevant aspects of the `encoding/csv` package.
 */

import go

/** Provides models of commonly used functions in the `encoding/csv` package. */
module EncodingCsv {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader) *Reader
      hasQualifiedName("encoding/csv", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("encoding/csv", "NewWriter") and
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
      // signature: func (*Reader) Read() (record []string, err error)
      hasQualifiedName("encoding/csv", "Reader", "Read") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader) ReadAll() (records [][]string, err error)
      hasQualifiedName("encoding/csv", "Reader", "ReadAll") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Writer) Write(record []string) error
      hasQualifiedName("encoding/csv", "Writer", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer) WriteAll(records [][]string) error
      hasQualifiedName("encoding/csv", "Writer", "WriteAll") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
