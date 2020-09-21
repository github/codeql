/**
 * Provides classes modeling security-relevant aspects of the `crypto/tls` package.
 */

import go

/** Provides models of commonly used functions in the `crypto/tls` package. */
module CryptoTls {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Client(conn net.Conn, config *Config) *Conn
      hasQualifiedName("crypto/tls", "Client") and
      (
        inp.isParameter(0) and outp.isResult()
        or
        inp.isResult() and outp.isParameter(0)
      )
      or
      // signature: func NewListener(inner net.Listener, config *Config) net.Listener
      hasQualifiedName("crypto/tls", "NewListener") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Server(conn net.Conn, config *Config) *Conn
      hasQualifiedName("crypto/tls", "Server") and
      (
        inp.isParameter(0) and outp.isResult()
        or
        inp.isResult() and outp.isParameter(0)
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
      // signature: func (*Conn).Read(b []byte) (int, error)
      this.hasQualifiedName("crypto/tls", "Conn", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Conn).Write(b []byte) (int, error)
      this.hasQualifiedName("crypto/tls", "Conn", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
