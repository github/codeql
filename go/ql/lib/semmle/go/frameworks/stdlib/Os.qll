/**
 * Provides classes modeling security-relevant aspects of the `os` package.
 */

import go

/** Provides models of commonly used functions in the `os` package. */
module Os {
  /** The `os.Exit` function, which ends the process. */
  private class Exit extends Function {
    Exit() { this.hasQualifiedName("os", "Exit") }

    override predicate mayReturnNormally() { none() }
  }

  // These models are not implemented using Models-as-Data because they represent reverse flow.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Pipe() (r *File, w *File, err error)
      this.hasQualifiedName("os", "Pipe") and
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
      // signature: func (*File) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("os", "File", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
