/**
 * Provides classes modeling security-relevant aspects of the `net/http` package.
 */

import go
private import semmle.go.dataflow.ExternalFlow

private class FlowSources extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "net/http;Request;true;Cookie;;;ReturnValue[0];remote",
        "net/http;Request;true;Cookies;;;ReturnValue.ArrayElement;remote",
        "net/http;Request;true;FormFile;;;ReturnValue[0..1];remote",
        "net/http;Request;true;FormValue;;;ReturnValue;remote",
        "net/http;Request;true;MultipartReader;;;ReturnValue[0];remote",
        "net/http;Request;true;PostFormValue;;;ReturnValue;remote",
        "net/http;Request;true;Referer;;;ReturnValue;remote",
        "net/http;Request;true;UserAgent;;;ReturnValue;remote"
      ]
  }
}

/** Provides models of commonly used functions in the `net/http` package. */
module NetHttp {
  /** An access to an HTTP request field whose value may be controlled by an untrusted user. */
  private class UserControlledRequestField extends UntrustedFlowSource::Range,
    DataFlow::FieldReadNode {
    UserControlledRequestField() {
      exists(string fieldName | this.getField().hasQualifiedName("net/http", "Request", fieldName) |
        fieldName =
          ["Body", "GetBody", "Form", "PostForm", "MultipartForm", "Header", "Trailer", "URL"]
      )
    }
  }

  /** The declaration of a variable which either is or has a field that implements the http.ResponseWriter type */
  private class StdlibResponseWriter extends HTTP::ResponseWriter::Range {
    SsaWithFields v;

    StdlibResponseWriter() {
      this = v.getBaseVariable().getSourceVariable() and
      exists(Type t | t.implements("net/http", "ResponseWriter") | v.getType() = t)
    }

    override DataFlow::Node getANode() { result = v.similar().getAUse().getASuccessor*() }

    /** Gets a header object that corresponds to this HTTP response. */
    DataFlow::MethodCallNode getAHeaderObject() {
      result.getTarget().getName() = "Header" and
      this.getANode() = result.getReceiver()
    }
  }

  private class HeaderWriteCall extends HTTP::HeaderWrite::Range, DataFlow::MethodCallNode {
    HeaderWriteCall() {
      this.getTarget().hasQualifiedName("net/http", "Header", "Add") or
      this.getTarget().hasQualifiedName("net/http", "Header", "Set")
    }

    override DataFlow::Node getName() { result = this.getArgument(0) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override HTTP::ResponseWriter getResponseWriter() {
      // find `v` in
      // ```
      // header := v.Header()
      // header.Add(...)
      // ```
      result.(StdlibResponseWriter).getAHeaderObject().getASuccessor*() = this.getReceiver()
    }
  }

  private class MapWrite extends HTTP::HeaderWrite::Range, DataFlow::Node {
    Write write;
    DataFlow::Node index;
    DataFlow::Node rhs;

    MapWrite() {
      this.getType().hasQualifiedName("net/http", "Header") and
      write.writesElement(this, index, rhs)
    }

    override DataFlow::Node getName() { result = index }

    override DataFlow::Node getValue() { result = rhs }

    override HTTP::ResponseWriter getResponseWriter() {
      // find `v` in
      // ```
      // header := v.Header()
      // header[...] = ...
      // ```
      result.(StdlibResponseWriter).getAHeaderObject().getASuccessor*() = this
    }
  }

  private class ResponseWriteHeaderCall extends HTTP::HeaderWrite::Range, DataFlow::MethodCallNode {
    ResponseWriteHeaderCall() {
      this.getTarget().implements("net/http", "ResponseWriter", "WriteHeader")
    }

    override string getHeaderName() { result = "status" }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = this.getArgument(0) }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = this.getReceiver() }
  }

  private class ResponseErrorCall extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
    ResponseErrorCall() { this.getTarget().hasQualifiedName("net/http", "Error") }

    override string getHeaderName() { result = "status" }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = this.getArgument(2) }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = this.getArgument(0) }
  }

  private class RequestBody extends HTTP::RequestBody::Range, DataFlow::ExprNode {
    RequestBody() {
      exists(Function newRequest |
        newRequest.hasQualifiedName("net/http", "NewRequest") and
        this = newRequest.getACall().getArgument(2)
      )
      or
      exists(Field body, Type request |
        request.hasQualifiedName("net/http", "Request") and
        body = request.getField("Body") and
        this = body.getAWrite().getRhs()
      )
    }
  }

  private class ResponseBody extends HTTP::ResponseBody::Range, DataFlow::ArgumentNode {
    DataFlow::Node responseWriter;

    ResponseBody() {
      exists(DataFlow::CallNode call |
        // A direct call to ResponseWriter.Write, conveying taint from the argument to the receiver
        call.getTarget().(Method).implements("net/http", "ResponseWriter", "Write") and
        this = call.getArgument(0) and
        responseWriter = call.(DataFlow::MethodCallNode).getReceiver()
      )
      or
      exists(TaintTracking::FunctionModel model |
        // A modelled function conveying taint from some input to the response writer,
        // e.g. `io.Copy(responseWriter, someTaintedReader)`
        model.taintStep(this, responseWriter) and
        responseWriter.getType().implements("net/http", "ResponseWriter")
      )
    }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = responseWriter }
  }

  private class RedirectCall extends HTTP::Redirect::Range, DataFlow::CallNode {
    RedirectCall() { this.getTarget().hasQualifiedName("net/http", "Redirect") }

    override DataFlow::Node getUrl() { result = this.getArgument(2) }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = this.getArgument(0) }
  }

  /** A call to a function in the `net/http` package that performs an HTTP request to a URL. */
  private class RequestCall extends HTTP::ClientRequest::Range, DataFlow::CallNode {
    RequestCall() {
      exists(string functionName |
        (
          this.getTarget().hasQualifiedName("net/http", functionName)
          or
          this.getTarget().(Method).hasQualifiedName("net/http", "Client", functionName)
        ) and
        (functionName = "Get" or functionName = "Post" or functionName = "PostForm")
      )
    }

    /** Gets the URL of the request. */
    override DataFlow::Node getUrl() { result = this.getArgument(0) }
  }

  /** A call to the Client.Do function in the `net/http` package. */
  private class ClientDo extends HTTP::ClientRequest::Range, DataFlow::MethodCallNode {
    ClientDo() { this.getTarget().hasQualifiedName("net/http", "Client", "Do") }

    override DataFlow::Node getUrl() {
      // A URL passed to `NewRequest`, whose result is passed to this `Do` call
      exists(DataFlow::CallNode call | call.getTarget().hasQualifiedName("net/http", "NewRequest") |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(1)
      )
      or
      // A URL passed to `NewRequestWithContext`, whose result is passed to this `Do` call
      exists(DataFlow::CallNode call |
        call.getTarget().hasQualifiedName("net/http", "NewRequestWithContext")
      |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(2)
      )
      or
      // A URL assigned to a request that is passed to this `Do` call
      exists(Write w, Field f |
        f.hasQualifiedName("net/http", "Request", "URL") and
        w.writesField(this.getArgument(0).getAPredecessor*(), f, result)
      )
    }
  }

  /** A call to the `Transport.RoundTrip` function in the `net/http` package. */
  private class TransportRoundTrip extends HTTP::ClientRequest::Range, DataFlow::MethodCallNode {
    TransportRoundTrip() { this.getTarget().hasQualifiedName("net/http", "Transport", "RoundTrip") }

    override DataFlow::Node getUrl() {
      // A URL passed to `NewRequest`, whose result is passed to this `RoundTrip` call
      exists(DataFlow::CallNode call | call.getTarget().hasQualifiedName("net/http", "NewRequest") |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(1)
      )
      or
      // A URL passed to `NewRequestWithContext`, whose result is passed to this `RoundTrip` call
      exists(DataFlow::CallNode call |
        call.getTarget().hasQualifiedName("net/http", "NewRequestWithContext")
      |
        this.getArgument(0) = call.getResult(0).getASuccessor*() and
        result = call.getArgument(2)
      )
      or
      // A URL assigned to a request that is passed to this `RoundTrip` call
      exists(Write w, Field f |
        f.hasQualifiedName("net/http", "Request", "URL") and
        w.writesField(this.getArgument(0).getAPredecessor*(), f, result)
      )
    }
  }

  /** Fields and methods of `net/http.Request` that are not generally exploitable in an open-redirect attack. */
  private class RedirectUnexploitableRequestFields extends HTTP::Redirect::UnexploitableSource {
    RedirectUnexploitableRequestFields() {
      exists(Field f, string fieldName |
        f.hasQualifiedName("net/http", "Request", fieldName) and
        this = f.getARead()
      |
        fieldName = ["Body", "GetBody", "PostForm", "MultipartForm", "Header", "Trailer"]
      )
      or
      exists(Method m, string methName |
        m.hasQualifiedName("net/http", "Request", methName) and
        this = m.getACall().getResult(0)
      |
        methName = ["Cookie", "Cookies", "MultipartReader", "PostFormValue", "Referer", "UserAgent"]
      )
    }
  }

  private class Handler extends HTTP::RequestHandler::Range {
    DataFlow::CallNode handlerReg;

    Handler() {
      exists(Function regFn | regFn = handlerReg.getTarget() |
        regFn.hasQualifiedName("net/http", ["Handle", "HandleFunc"]) or
        regFn.(Method).hasQualifiedName("net/http", "ServeMux", ["Handle", "HandleFunc"])
      ) and
      this = handlerReg.getArgument(1)
    }

    override predicate guardedBy(DataFlow::Node check) { check = handlerReg.getArgument(0) }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func CanonicalHeaderKey(s string) string
      this.hasQualifiedName("net/http", "CanonicalHeaderKey") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Error(w ResponseWriter, error string, code int)
      this.hasQualifiedName("net/http", "Error") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func MaxBytesReader(w ResponseWriter, r io.ReadCloser, n int64) io.ReadCloser
      this.hasQualifiedName("net/http", "MaxBytesReader") and
      (inp.isParameter(1) and outp.isResult())
      or
      // signature: func NewRequest(method, url string, body io.Reader) (*Request, error)
      this.hasQualifiedName("net/http", "NewRequest") and
      (inp.isParameter(1) and outp.isResult(0))
      or
      // signature: func NewRequestWithContext(ctx context.Context, method, url string, body io.Reader) (*Request, error)
      this.hasQualifiedName("net/http", "NewRequestWithContext") and
      (inp.isParameter(2) and outp.isResult(0))
      or
      // signature: func ReadRequest(b *bufio.Reader) (*Request, error)
      this.hasQualifiedName("net/http", "ReadRequest") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func ReadResponse(r *bufio.Reader, req *Request) (*Response, error)
      this.hasQualifiedName("net/http", "ReadResponse") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func SetCookie(w ResponseWriter, cookie *Cookie)
      this.hasQualifiedName("net/http", "SetCookie") and
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
      // signature: func (Header) Add(key string, value string)
      this.hasQualifiedName("net/http", "Header", "Add") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (Header) Clone() Header
      this.hasQualifiedName("net/http", "Header", "Clone") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Header) Get(key string) string
      this.hasQualifiedName("net/http", "Header", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Header) Set(key string, value string)
      this.hasQualifiedName("net/http", "Header", "Set") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (Header) Values(key string) []string
      this.hasQualifiedName("net/http", "Header", "Values") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Header) Write(w io.Writer) error
      this.hasQualifiedName("net/http", "Header", "Write") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (Header) WriteSubset(w io.Writer, exclude map[string]bool) error
      this.hasQualifiedName("net/http", "Header", "WriteSubset") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Request) AddCookie(c *Cookie)
      this.hasQualifiedName("net/http", "Request", "AddCookie") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Request) Clone(ctx context.Context) *Request
      this.hasQualifiedName("net/http", "Request", "Clone") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Request) Write(w io.Writer) error
      this.hasQualifiedName("net/http", "Request", "Write") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Request) WriteProxy(w io.Writer) error
      this.hasQualifiedName("net/http", "Request", "WriteProxy") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Response) Write(w io.Writer) error
      this.hasQualifiedName("net/http", "Response", "Write") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Transport) Clone() *Transport
      this.hasQualifiedName("net/http", "Transport", "Clone") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Hijacker) Hijack() (net.Conn, *bufio.ReadWriter, error)
      this.implements("net/http", "Hijacker", "Hijack") and
      (inp.isReceiver() and outp.isResult([0, 1]))
      or
      // signature: func (ResponseWriter) Write([]byte) (int, error)
      this.implements("net/http", "ResponseWriter", "Write") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
