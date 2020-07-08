/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

import go

/** Provides models of commonly used functions in the `archive/zip` package. */
module ArchiveZipTaintTracking {
  private class FunctionTaintTracking extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionTaintTracking() {
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

  private class MethodAndInterfaceTaintTracking extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodAndInterfaceTaintTracking() {
      // Methods:
      // signature: func (*File).Open() (io.ReadCloser, error)
      this.(Method).hasQualifiedName("archive/zip", "File", "Open") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*FileHeader).FileInfo() os.FileInfo
      this.(Method).hasQualifiedName("archive/zip", "FileHeader", "FileInfo") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*FileHeader).Mode() (mode os.FileMode)
      this.(Method).hasQualifiedName("archive/zip", "FileHeader", "Mode") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*FileHeader).SetMode(mode os.FileMode)
      this.(Method).hasQualifiedName("archive/zip", "FileHeader", "SetMode") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Reader).RegisterDecompressor(method uint16, dcomp Decompressor)
      this.(Method).hasQualifiedName("archive/zip", "Reader", "RegisterDecompressor") and
      (inp.isParameter(1) and outp.isReceiver())
      or
      // signature: func (*Writer).Create(name string) (io.Writer, error)
      this.(Method).hasQualifiedName("archive/zip", "Writer", "Create") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer).CreateHeader(fh *FileHeader) (io.Writer, error)
      this.(Method).hasQualifiedName("archive/zip", "Writer", "CreateHeader") and
      (
        (inp.isParameter(0) or inp.isResult(0)) and
        outp.isReceiver()
      )
      or
      // signature: func (*Writer).RegisterCompressor(method uint16, comp Compressor)
      this.(Method).hasQualifiedName("archive/zip", "Writer", "RegisterCompressor") and
      (inp.isParameter(1) and outp.isReceiver())
      or
      // signature: func (*Writer).SetComment(comment string) error
      this.(Method).hasQualifiedName("archive/zip", "Writer", "SetComment") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
