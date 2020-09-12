/**
 * Provides classes modeling security-relevant aspects of the `net/http` package.
 */

import go

/** Provides models of commonly used functions in the `net/http` package. */
module NetHttp {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func CanonicalHeaderKey(s string) string
      hasQualifiedName("net/http", "CanonicalHeaderKey") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Error(w ResponseWriter, error string, code int)
      hasQualifiedName("net/http", "Error") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func MaxBytesReader(w ResponseWriter, r io.ReadCloser, n int64) io.ReadCloser
      hasQualifiedName("net/http", "MaxBytesReader") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func ReadRequest(b *bufio.Reader) (*Request, error)
      hasQualifiedName("net/http", "ReadRequest") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func ReadResponse(r *bufio.Reader, req *Request) (*Response, error)
      hasQualifiedName("net/http", "ReadResponse") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func SetCookie(w ResponseWriter, cookie *Cookie)
      hasQualifiedName("net/http", "SetCookie") and
      (inp.isParameter(1) and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (Header).Add(key string, value string)
      this.hasQualifiedName("net/http", "Header", "Add") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (Header).Clone() Header
      this.hasQualifiedName("net/http", "Header", "Clone") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Header).Get(key string) string
      this.hasQualifiedName("net/http", "Header", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Header).Set(key string, value string)
      this.hasQualifiedName("net/http", "Header", "Set") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (Header).Values(key string) []string
      this.hasQualifiedName("net/http", "Header", "Values") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Header).Write(w io.Writer) error
      this.hasQualifiedName("net/http", "Header", "Write") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (Header).WriteSubset(w io.Writer, exclude map[string]bool) error
      this.hasQualifiedName("net/http", "Header", "WriteSubset") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Request).AddCookie(c *Cookie)
      this.hasQualifiedName("net/http", "Request", "AddCookie") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Request).Clone(ctx context.Context) *Request
      this.hasQualifiedName("net/http", "Request", "Clone") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Request).Write(w io.Writer) error
      this.hasQualifiedName("net/http", "Request", "Write") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Request).WriteProxy(w io.Writer) error
      this.hasQualifiedName("net/http", "Request", "WriteProxy") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Response).Write(w io.Writer) error
      this.hasQualifiedName("net/http", "Response", "Write") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Transport).Clone() *Transport
      this.hasQualifiedName("net/http", "Transport", "Clone") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Hijacker).Hijack() (net.Conn, *bufio.ReadWriter, error)
      this.implements("net/http", "Hijacker", "Hijack") and
      (inp.isReceiver() and outp.isResult([0, 1]))
      or
      // signature: func (ResponseWriter).Write([]byte) (int, error)
      this.implements("net/http", "ResponseWriter", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
