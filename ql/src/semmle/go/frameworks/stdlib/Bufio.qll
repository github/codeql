/**
 * Provides classes modeling security-relevant aspects of the `bufio` package.
 */

import go

/** Provides models of commonly used functions in the `bufio` package. */
module Bufio {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReadWriter(r *Reader, w *Writer) *ReadWriter
      hasQualifiedName("bufio", "NewReadWriter") and
      (
        inp.isParameter(0) and outp.isResult()
        or
        inp.isResult() and outp.isParameter(1)
      )
      or
      // signature: func NewReader(rd io.Reader) *Reader
      hasQualifiedName("bufio", "NewReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewReaderSize(rd io.Reader, size int) *Reader
      hasQualifiedName("bufio", "NewReaderSize") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewScanner(r io.Reader) *Scanner
      hasQualifiedName("bufio", "NewScanner") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("bufio", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewWriterSize(w io.Writer, size int) *Writer
      hasQualifiedName("bufio", "NewWriterSize") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func ScanBytes(data []byte, atEOF bool) (advance int, token []byte, err error)
      hasQualifiedName("bufio", "ScanBytes") and
      (inp.isParameter(0) and outp.isResult(1))
      or
      // signature: func ScanLines(data []byte, atEOF bool) (advance int, token []byte, err error)
      hasQualifiedName("bufio", "ScanLines") and
      (inp.isParameter(0) and outp.isResult(1))
      or
      // signature: func ScanRunes(data []byte, atEOF bool) (advance int, token []byte, err error)
      hasQualifiedName("bufio", "ScanRunes") and
      (inp.isParameter(0) and outp.isResult(1))
      or
      // signature: func ScanWords(data []byte, atEOF bool) (advance int, token []byte, err error)
      hasQualifiedName("bufio", "ScanWords") and
      (inp.isParameter(0) and outp.isResult(1))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Reader).Peek(n int) ([]byte, error)
      this.hasQualifiedName("bufio", "Reader", "Peek") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).ReadByte() (byte, error)
      this.hasQualifiedName("bufio", "Reader", "ReadByte") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).ReadBytes(delim byte) ([]byte, error)
      this.hasQualifiedName("bufio", "Reader", "ReadBytes") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).ReadLine() (line []byte, isPrefix bool, err error)
      this.hasQualifiedName("bufio", "Reader", "ReadLine") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).ReadRune() (r rune, size int, err error)
      this.hasQualifiedName("bufio", "Reader", "ReadRune") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).ReadSlice(delim byte) (line []byte, err error)
      this.hasQualifiedName("bufio", "Reader", "ReadSlice") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).ReadString(delim byte) (string, error)
      this.hasQualifiedName("bufio", "Reader", "ReadString") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Reader).Reset(r io.Reader)
      this.hasQualifiedName("bufio", "Reader", "Reset") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Reader).WriteTo(w io.Writer) (n int64, err error)
      this.hasQualifiedName("bufio", "Reader", "WriteTo") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Scanner).Bytes() []byte
      this.hasQualifiedName("bufio", "Scanner", "Bytes") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Scanner).Text() string
      this.hasQualifiedName("bufio", "Scanner", "Text") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Writer).ReadFrom(r io.Reader) (n int64, err error)
      this.hasQualifiedName("bufio", "Writer", "ReadFrom") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer).Reset(w io.Writer)
      this.hasQualifiedName("bufio", "Writer", "Reset") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Writer).Write(p []byte) (nn int, err error)
      this.hasQualifiedName("bufio", "Writer", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer).WriteByte(c byte) error
      this.hasQualifiedName("bufio", "Writer", "WriteByte") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer).WriteRune(r rune) (size int, err error)
      this.hasQualifiedName("bufio", "Writer", "WriteRune") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer).WriteString(s string) (int, error)
      this.hasQualifiedName("bufio", "Writer", "WriteString") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
