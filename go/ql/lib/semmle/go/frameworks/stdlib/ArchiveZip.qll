/**
 * Provides classes modeling security-relevant aspects of the `archive/zip` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `archive/zip` package. */
module ArchiveZip {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewWriter(w io.Writer) *Writer
      this.hasQualifiedName("archive/zip", "NewWriter") and
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
      // signature: func (*Writer) Create(name string) (io.Writer, error)
      this.hasQualifiedName("archive/zip", "Writer", "Create") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreateRaw(fh *FileHeader) (io.Writer, error)
      this.hasQualifiedName("archive/zip", "Writer", "CreateRaw") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*Writer) CreateHeader(fh *FileHeader) (io.Writer, error)
      this.hasQualifiedName("archive/zip", "Writer", "CreateHeader") and
      (inp.isResult(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
