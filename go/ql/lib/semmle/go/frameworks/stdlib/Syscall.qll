/**
 * Provides classes modeling security-relevant aspects of the `syscall` package.
 */

import go

/** Provides models of commonly used functions in the `syscall` package. */
module Syscall {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func BytePtrFromString(s string) (*byte, error)
      hasQualifiedName("syscall", "BytePtrFromString") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func ByteSliceFromString(s string) ([]byte, error)
      hasQualifiedName("syscall", "ByteSliceFromString") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func StringBytePtr(s string) *byte
      hasQualifiedName("syscall", "StringBytePtr") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func StringByteSlice(s string) []byte
      hasQualifiedName("syscall", "StringByteSlice") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func StringSlicePtr(ss []string) []*byte
      hasQualifiedName("syscall", "StringSlicePtr") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (RawConn) Read(f func(fd uintptr) (done bool)) error
      implements("syscall", "RawConn", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (Conn) SyscallConn() (RawConn, error)
      implements("syscall", "Conn", "SyscallConn") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (RawConn) Write(f func(fd uintptr) (done bool)) error
      implements("syscall", "RawConn", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
