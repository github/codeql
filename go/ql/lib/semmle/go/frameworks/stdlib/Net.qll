/**
 * Provides classes modeling security-relevant aspects of the `net` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `net` package. */
module Net {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func FileConn(f *os.File) (c Conn, err error)
      this.hasQualifiedName("net", "FileConn") and
      (inp.isResult(0) and outp.isParameter(0))
      or
      // signature: func FilePacketConn(f *os.File) (c PacketConn, err error)
      this.hasQualifiedName("net", "FilePacketConn") and
      (inp.isResult(0) and outp.isParameter(0))
      or
      // signature: func Pipe() (Conn, Conn)
      this.hasQualifiedName("net", "Pipe") and
      (
        inp.isResult(0) and outp.isResult(1)
        or
        inp.isResult(1) and outp.isResult(0)
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*IPConn) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("net", "IPConn", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*TCPConn) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("net", "TCPConn", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*TCPListener) File() (f *os.File, err error)
      this.hasQualifiedName("net", "TCPListener", "File") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*TCPListener) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("net", "TCPListener", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*UDPConn) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("net", "UDPConn", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*UnixConn) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("net", "UnixConn", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*UnixListener) File() (f *os.File, err error)
      this.hasQualifiedName("net", "UnixListener", "File") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*UnixListener) SyscallConn() (syscall.RawConn, error)
      this.hasQualifiedName("net", "UnixListener", "SyscallConn") and
      (inp.isResult(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
