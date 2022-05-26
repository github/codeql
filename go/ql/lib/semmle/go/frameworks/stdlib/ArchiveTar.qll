/**
 * Provides classes modeling security-relevant aspects of the `archive/tar` package.
 */

import go
private import semmle.go.dataflow.ExternalFlow

private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row = ["archive/tar;;true;FileInfoHeader;;;Argument[0];ReturnValue[0];taint"]
  }
}

/** Provides models of commonly used functions in the `archive/tar` package. */
module ArchiveTar {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReader(r io.Reader) *Reader
      hasQualifiedName("archive/tar", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("archive/tar", "NewWriter") and
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
      // Methods:
      // signature: func (*Header) FileInfo() os.FileInfo
      hasQualifiedName("archive/tar", "Header", "FileInfo") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Reader) Next() (*Header, error)
      hasQualifiedName("archive/tar", "Reader", "Next") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Writer) WriteHeader(hdr *Header) error
      hasQualifiedName("archive/tar", "Writer", "WriteHeader") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
