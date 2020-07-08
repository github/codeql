/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go

/** Provides models of commonly used functions in the `archive/tar` package. */
module ArchiveTarTaintTracking {
  private class FunctionTaintTracking extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionTaintTracking() {
      // signature: func FileInfoHeader(fi os.FileInfo, link string) (*Header, error)
      hasQualifiedName("archive/tar", "FileInfoHeader") and
      (inp.isParameter(0) and outp.isResult(0))
      or
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

  private class MethodAndInterfaceTaintTracking extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodAndInterfaceTaintTracking() {
      // Methods:
      // signature: func (*Header).FileInfo() os.FileInfo
      this.(Method).hasQualifiedName("archive/tar", "Header", "FileInfo") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Reader).Next() (*Header, error)
      this.(Method).hasQualifiedName("archive/tar", "Reader", "Next") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).Read(b []byte) (int, error)
      this.(Method).hasQualifiedName("archive/tar", "Reader", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Writer).Write(b []byte) (int, error)
      this.(Method).hasQualifiedName("archive/tar", "Writer", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer).WriteHeader(hdr *Header) error
      this.(Method).hasQualifiedName("archive/tar", "Writer", "WriteHeader") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
