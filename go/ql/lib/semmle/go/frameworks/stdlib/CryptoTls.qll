/**
 * Provides classes modeling security-relevant aspects of the `crypto/tls` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `crypto/tls` package. */
module CryptoTls {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Client(conn net.Conn, config *Config) *Conn
      this.hasQualifiedName("crypto/tls", "Client") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func Server(conn net.Conn, config *Config) *Conn
      this.hasQualifiedName("crypto/tls", "Server") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
