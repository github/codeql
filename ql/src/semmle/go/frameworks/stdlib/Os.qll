/**
 * Provides classes modeling security-relevant aspects of the `os` package.
 */

import go

/** Provides models of commonly used functions in the `os` package. */
module Os {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Expand(s string, mapping func(string) string) string
      hasQualifiedName("os", "Expand") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func ExpandEnv(s string) string
      hasQualifiedName("os", "ExpandEnv") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewFile(fd uintptr, name string) *File
      hasQualifiedName("os", "NewFile") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Pipe() (r *File, w *File, err error)
      hasQualifiedName("os", "Pipe") and
      (inp.isResult(1) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*File).Fd() uintptr
      this.hasQualifiedName("os", "File", "Fd") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*File).Read(b []byte) (n int, err error)
      this.hasQualifiedName("os", "File", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*File).ReadAt(b []byte, off int64) (n int, err error)
      this.hasQualifiedName("os", "File", "ReadAt") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*File).ReadFrom(r io.Reader) (n int64, err error)
      this.hasQualifiedName("os", "File", "ReadFrom") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*File).SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("os", "File", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*File).Write(b []byte) (n int, err error)
      this.hasQualifiedName("os", "File", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*File).WriteAt(b []byte, off int64) (n int, err error)
      this.hasQualifiedName("os", "File", "WriteAt") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*File).WriteString(s string) (n int, err error)
      this.hasQualifiedName("os", "File", "WriteString") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
