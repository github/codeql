/**
 * Provides classes modeling security-relevant aspects of the `net` package.
 */

import go

/** Provides models of commonly used functions in the `net` package. */
module Net {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func FileConn(f *os.File) (c Conn, err error)
      hasQualifiedName("net", "FileConn") and
      (
        inp.isParameter(0) and outp.isResult(0)
        or
        inp.isResult(0) and outp.isParameter(0)
      )
      or
      // signature: func FilePacketConn(f *os.File) (c PacketConn, err error)
      hasQualifiedName("net", "FilePacketConn") and
      (
        inp.isParameter(0) and outp.isResult(0)
        or
        inp.isResult(0) and outp.isParameter(0)
      )
      or
      // signature: func JoinHostPort(host string, port string) string
      hasQualifiedName("net", "JoinHostPort") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Pipe() (Conn, Conn)
      hasQualifiedName("net", "Pipe") and
      (
        inp.isResult(0) and outp.isResult(1)
        or
        inp.isResult(1) and outp.isResult(0)
      )
      or
      // signature: func SplitHostPort(hostport string) (host string, port string, err error)
      hasQualifiedName("net", "SplitHostPort") and
      (inp.isParameter(0) and outp.isResult([0, 1]))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*IPConn) ReadFromIP(b []byte) (int, *IPAddr, error)
      hasQualifiedName("net", "IPConn", "ReadFromIP") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*IPConn) ReadMsgIP(b []byte, oob []byte) (n int, oobn int, flags int, addr *IPAddr, err error)
      hasQualifiedName("net", "IPConn", "ReadMsgIP") and
      (inp.isReceiver() and outp.isParameter(_))
      or
      // signature: func (*IPConn) SyscallConn() (syscall.RawConn, error)
      hasQualifiedName("net", "IPConn", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*IPConn) WriteMsgIP(b []byte, oob []byte, addr *IPAddr) (n int, oobn int, err error)
      hasQualifiedName("net", "IPConn", "WriteMsgIP") and
      (inp.isParameter([0, 1]) and outp.isReceiver())
      or
      // signature: func (*IPConn) WriteToIP(b []byte, addr *IPAddr) (int, error)
      hasQualifiedName("net", "IPConn", "WriteToIP") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*TCPConn) SyscallConn() (syscall.RawConn, error)
      hasQualifiedName("net", "TCPConn", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*TCPListener) File() (f *os.File, err error)
      hasQualifiedName("net", "TCPListener", "File") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*TCPListener) SyscallConn() (syscall.RawConn, error)
      hasQualifiedName("net", "TCPListener", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*UDPConn) ReadFromUDP(b []byte) (int, *UDPAddr, error)
      hasQualifiedName("net", "UDPConn", "ReadFromUDP") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*UDPConn) ReadMsgUDP(b []byte, oob []byte) (n int, oobn int, flags int, addr *UDPAddr, err error)
      hasQualifiedName("net", "UDPConn", "ReadMsgUDP") and
      (inp.isReceiver() and outp.isParameter(_))
      or
      // signature: func (*UDPConn) SyscallConn() (syscall.RawConn, error)
      hasQualifiedName("net", "UDPConn", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*UDPConn) WriteMsgUDP(b []byte, oob []byte, addr *UDPAddr) (n int, oobn int, err error)
      hasQualifiedName("net", "UDPConn", "WriteMsgUDP") and
      (inp.isParameter([0, 1]) and outp.isReceiver())
      or
      // signature: func (*UDPConn) WriteToUDP(b []byte, addr *UDPAddr) (int, error)
      hasQualifiedName("net", "UDPConn", "WriteToUDP") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*UnixConn) ReadFromUnix(b []byte) (int, *UnixAddr, error)
      hasQualifiedName("net", "UnixConn", "ReadFromUnix") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*UnixConn) ReadMsgUnix(b []byte, oob []byte) (n int, oobn int, flags int, addr *UnixAddr, err error)
      hasQualifiedName("net", "UnixConn", "ReadMsgUnix") and
      (inp.isReceiver() and outp.isParameter(_))
      or
      // signature: func (*UnixConn) SyscallConn() (syscall.RawConn, error)
      hasQualifiedName("net", "UnixConn", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*UnixConn) WriteMsgUnix(b []byte, oob []byte, addr *UnixAddr) (n int, oobn int, err error)
      hasQualifiedName("net", "UnixConn", "WriteMsgUnix") and
      (inp.isParameter([0, 1]) and outp.isReceiver())
      or
      // signature: func (*UnixConn) WriteToUnix(b []byte, addr *UnixAddr) (int, error)
      hasQualifiedName("net", "UnixConn", "WriteToUnix") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*UnixListener) File() (f *os.File, err error)
      hasQualifiedName("net", "UnixListener", "File") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*UnixListener) SyscallConn() (syscall.RawConn, error)
      hasQualifiedName("net", "UnixListener", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (Conn) Read(b []byte) (n int, err error)
      implements("net", "Conn", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (PacketConn) ReadFrom(p []byte) (n int, addr Addr, err error)
      implements("net", "PacketConn", "ReadFrom") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (Addr) String() string
      implements("net", "Addr", "String") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Conn) Write(b []byte) (n int, err error)
      implements("net", "Conn", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (PacketConn) WriteTo(p []byte, addr Addr) (n int, err error)
      implements("net", "PacketConn", "WriteTo") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
