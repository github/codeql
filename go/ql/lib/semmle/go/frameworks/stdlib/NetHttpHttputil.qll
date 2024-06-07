/**
 * Provides classes modeling security-relevant aspects of the `net/http/httputil` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow.
/** Provides models of commonly used functions in the `net/http/httputil` package. */
module NetHttpHttputil {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewChunkedWriter(w io.Writer) io.WriteCloser
      this.hasQualifiedName("net/http/httputil", "NewChunkedWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewClientConn(c net.Conn, r *bufio.Reader) *ClientConn
      this.hasQualifiedName("net/http/httputil", "NewClientConn") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewProxyClientConn(c net.Conn, r *bufio.Reader) *ClientConn
      this.hasQualifiedName("net/http/httputil", "NewProxyClientConn") and
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
      // signature: func (*ClientConn) Hijack() (c net.Conn, r *bufio.Reader)
      this.hasQualifiedName("net/http/httputil", "ClientConn", "Hijack") and
      (inp.isResult(0) and outp.isReceiver())
      or
      // signature: func (*ServerConn) Hijack() (net.Conn, *bufio.Reader)
      this.hasQualifiedName("net/http/httputil", "ServerConn", "Hijack") and
      (inp.isResult(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
