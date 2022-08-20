/**
 * Provides classes modeling security-relevant aspects of the `net/http/httputil` package.
 */

import go

/** Provides models of commonly used functions in the `net/http/httputil` package. */
module NetHttpHttputil {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func DumpRequest(req *net/http.Request, body bool) ([]byte, error)
      hasQualifiedName("net/http/httputil", "DumpRequest") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func DumpRequestOut(req *net/http.Request, body bool) ([]byte, error)
      hasQualifiedName("net/http/httputil", "DumpRequestOut") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func DumpResponse(resp *net/http.Response, body bool) ([]byte, error)
      hasQualifiedName("net/http/httputil", "DumpResponse") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func NewChunkedReader(r io.Reader) io.Reader
      hasQualifiedName("net/http/httputil", "NewChunkedReader") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func NewChunkedWriter(w io.Writer) io.WriteCloser
      hasQualifiedName("net/http/httputil", "NewChunkedWriter") and
      (inp.isResult() and outp.isParameter(0))
      or
      // signature: func NewClientConn(c net.Conn, r *bufio.Reader) *ClientConn
      hasQualifiedName("net/http/httputil", "NewClientConn") and
      (
        inp.isParameter(_) and outp.isResult()
        or
        inp.isResult() and outp.isParameter(0)
      )
      or
      // signature: func NewProxyClientConn(c net.Conn, r *bufio.Reader) *ClientConn
      hasQualifiedName("net/http/httputil", "NewProxyClientConn") and
      (
        inp.isParameter(_) and outp.isResult()
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
      // signature: func (*ClientConn) Hijack() (c net.Conn, r *bufio.Reader)
      hasQualifiedName("net/http/httputil", "ClientConn", "Hijack") and
      (
        inp.isReceiver() and outp.isResult(_)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (*ServerConn) Hijack() (net.Conn, *bufio.Reader)
      hasQualifiedName("net/http/httputil", "ServerConn", "Hijack") and
      (
        inp.isReceiver() and outp.isResult(_)
        or
        inp.isResult(0) and outp.isReceiver()
      )
      or
      // signature: func (BufferPool) Get() []byte
      implements("net/http/httputil", "BufferPool", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (BufferPool) Put([]byte)
      implements("net/http/httputil", "BufferPool", "Put") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
