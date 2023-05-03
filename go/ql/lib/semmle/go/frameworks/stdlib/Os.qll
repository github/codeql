/**
 * Provides classes modeling security-relevant aspects of the `os` package.
 */

import go

/** Provides models of commonly used functions in the `os` package. */
module Os {
  /**
   * A call to a function in `os` that accesses the file system.
   */
  private class OsFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathidx;

    OsFileSystemAccess() {
      exists(string fn | this.getTarget().hasQualifiedName("os", fn) |
        fn = "Chdir" and pathidx = 0
        or
        fn = "Chmod" and pathidx = 0
        or
        fn = "Chown" and pathidx = 0
        or
        fn = "Chtimes" and pathidx = 0
        or
        fn = "Create" and pathidx = 0
        or
        fn = "Lchown" and pathidx = 0
        or
        fn = "Link" and pathidx in [0 .. 1]
        or
        fn = "Lstat" and pathidx = 0
        or
        fn = "Mkdir" and pathidx = 0
        or
        fn = "MkdirAll" and pathidx = 0
        or
        fn = "NewFile" and pathidx = 1
        or
        fn = "Open" and pathidx = 0
        or
        fn = "OpenFile" and pathidx = 0
        or
        fn = "Readlink" and pathidx = 0
        or
        fn = "Remove" and pathidx = 0
        or
        fn = "RemoveAll" and pathidx = 0
        or
        fn = "Rename" and pathidx in [0 .. 1]
        or
        fn = "Stat" and pathidx = 0
        or
        fn = "Symlink" and pathidx in [0 .. 1]
        or
        fn = "Truncate" and pathidx = 0
        or
        fn = "DirFS" and pathidx = 0
        or
        fn = "ReadDir" and pathidx = 0
        or
        fn = "ReadFile" and pathidx = 0
        or
        fn = "MkdirTemp" and pathidx in [0 .. 1]
        or
        fn = "CreateTemp" and pathidx in [0 .. 1]
        or
        fn = "WriteFile" and pathidx = 0
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(pathidx) }
  }

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
