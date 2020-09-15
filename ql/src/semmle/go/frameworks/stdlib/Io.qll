/**
 * Provides classes modeling security-relevant aspects of the `io` package.
 */

import go

/** Provides models of commonly used functions in the `io` package. */
module Io {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Copy(dst Writer, src Reader) (written int64, err error)
      hasQualifiedName("io", "Copy") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func CopyBuffer(dst Writer, src Reader, buf []byte) (written int64, err error)
      hasQualifiedName("io", "CopyBuffer") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func CopyN(dst Writer, src Reader, n int64) (written int64, err error)
      hasQualifiedName("io", "CopyN") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func LimitReader(r Reader, n int64) Reader
      hasQualifiedName("io", "LimitReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func MultiReader(readers ...Reader) Reader
      hasQualifiedName("io", "MultiReader") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func MultiWriter(writers ...Writer) Writer
      hasQualifiedName("io", "MultiWriter") and
      (inp.isResult() and outp.isParameter(_))
      or
      // signature: func NewSectionReader(r ReaderAt, off int64, n int64) *SectionReader
      hasQualifiedName("io", "NewSectionReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Pipe() (*PipeReader, *PipeWriter)
      hasQualifiedName("io", "Pipe") and
      (inp.isResult(1) and outp.isResult(0))
      or
      // signature: func ReadAtLeast(r Reader, buf []byte, min int) (n int, err error)
      hasQualifiedName("io", "ReadAtLeast") and
      (inp.isParameter(0) and outp.isParameter(1))
      or
      // signature: func ReadFull(r Reader, buf []byte) (n int, err error)
      hasQualifiedName("io", "ReadFull") and
      (inp.isParameter(0) and outp.isParameter(1))
      or
      // signature: func TeeReader(r Reader, w Writer) Reader
      hasQualifiedName("io", "TeeReader") and
      (
        inp.isParameter(0) and
        (outp.isParameter(1) or outp.isResult())
      )
      or
      // signature: func WriteString(w Writer, s string) (n int, err error)
      hasQualifiedName("io", "WriteString") and
      (inp.isParameter(1) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*LimitedReader).Read(p []byte) (n int, err error)
      this.hasQualifiedName("io", "LimitedReader", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*PipeReader).Read(data []byte) (n int, err error)
      this.hasQualifiedName("io", "PipeReader", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*PipeWriter).Write(data []byte) (n int, err error)
      this.hasQualifiedName("io", "PipeWriter", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*SectionReader).Read(p []byte) (n int, err error)
      this.hasQualifiedName("io", "SectionReader", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*SectionReader).ReadAt(p []byte, off int64) (n int, err error)
      this.hasQualifiedName("io", "SectionReader", "ReadAt") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (Reader).Read(p []byte) (n int, err error)
      this.implements("io", "Reader", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (ReaderAt).ReadAt(p []byte, off int64) (n int, err error)
      this.implements("io", "ReaderAt", "ReadAt") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (ReaderFrom).ReadFrom(r Reader) (n int64, err error)
      this.implements("io", "ReaderFrom", "ReadFrom") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (Writer).Write(p []byte) (n int, err error)
      this.implements("io", "Writer", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (WriterAt).WriteAt(p []byte, off int64) (n int, err error)
      this.implements("io", "WriterAt", "WriteAt") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (StringWriter).WriteString(s string) (n int, err error)
      this.implements("io", "StringWriter", "WriteString") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (WriterTo).WriteTo(w Writer) (n int64, err error)
      this.implements("io", "WriterTo", "WriteTo") and
      (inp.isReceiver() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
