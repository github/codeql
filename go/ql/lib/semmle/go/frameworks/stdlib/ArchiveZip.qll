/**
 * Provides classes modeling security-relevant aspects of the `archive/zip` package.
 */

import go

/** Provides models of commonly used functions in the `archive/zip` package. */
module ArchiveZip {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func FileInfoHeader(fi os.FileInfo) (*FileHeader, error)
      hasQualifiedName("archive/zip", "FileInfoHeader") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewReader(r io.ReaderAt, size int64) (*Reader, error)
      hasQualifiedName("archive/zip", "NewReader") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewWriter(w io.Writer) *Writer
      hasQualifiedName("archive/zip", "NewWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func OpenReader(name string) (*ReadCloser, error)
      hasQualifiedName("archive/zip", "OpenReader") and
      (inp.isParameter(0) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*File) Open() (io.ReadCloser, error)
      hasQualifiedName("archive/zip", "File", "Open") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*File) OpenRaw() (io.Reader, error)
      hasQualifiedName("archive/zip", "File", "OpenRaw") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Writer) Copy(f *File) error
      hasQualifiedName("archive/zip", "Writer", "Copy") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Writer) Create(name string) (io.Writer, error)
      hasQualifiedName("archive/zip", "Writer", "Create") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreateRaw(fh *FileHeader) (io.Writer, error)
      hasQualifiedName("archive/zip", "Writer", "CreateRaw") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreateHeader(fh *FileHeader) (io.Writer, error)
      hasQualifiedName("archive/zip", "Writer", "CreateHeader") and
      (inp.isResult(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
