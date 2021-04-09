/**
 * Provides classes for working with concepts from the [`clevergo.tech/clevergo@v0.5.2`](https://pkg.go.dev/clevergo.tech/clevergo@v0.5.2) package.
 */

import go

/**
 * Provides classes for working with concepts from the [`clevergo.tech/clevergo@v0.5.2`](https://pkg.go.dev/clevergo.tech/clevergo@v0.5.2) package.
 */
private module CleverGo {
  /** Gets the package path. */
  bindingset[result]
  string packagePath() {
    result = package(["clevergo.tech/clevergo", "github.com/clevergo/clevergo"], "")
  }

  /**
   * Provides models of untrusted flow sources.
   */
  private class UntrustedSources extends UntrustedFlowSource::Range {
    UntrustedSources() {
      // Methods on types of package: clevergo.tech/clevergo@v0.5.2
      exists(string receiverName, string methodName, Method mtd, FunctionOutput out |
        this = out.getExitNode(mtd.getACall()) and
        mtd.hasQualifiedName(packagePath(), receiverName, methodName)
      |
        receiverName = "Context" and
        (
          // signature: func (*Context).BasicAuth() (username string, password string, ok bool)
          methodName = "BasicAuth" and
          out.isResult([0, 1])
          or
          // signature: func (*Context).Decode(v interface{}) (err error)
          methodName = "Decode" and
          out.isParameter(0)
          or
          // signature: func (*Context).DefaultQuery(key string, defaultVlue string) string
          methodName = "DefaultQuery" and
          out.isResult()
          or
          // signature: func (*Context).FormValue(key string) string
          methodName = "FormValue" and
          out.isResult()
          or
          // signature: func (*Context).GetHeader(name string) string
          methodName = "GetHeader" and
          out.isResult()
          or
          // signature: func (*Context).PostFormValue(key string) string
          methodName = "PostFormValue" and
          out.isResult()
          or
          // signature: func (*Context).QueryParam(key string) string
          methodName = "QueryParam" and
          out.isResult()
          or
          // signature: func (*Context).QueryParams() net/url.Values
          methodName = "QueryParams" and
          out.isResult()
          or
          // signature: func (*Context).QueryString() string
          methodName = "QueryString" and
          out.isResult()
        )
        or
        receiverName = "Params" and
        (
          // signature: func (Params).String(name string) string
          methodName = "String" and
          out.isResult()
        )
      )
      or
      // Interfaces of package: clevergo.tech/clevergo@v0.5.2
      exists(string interfaceName, string methodName, Method mtd, FunctionOutput out |
        this = out.getExitNode(mtd.getACall()) and
        mtd.implements(packagePath(), interfaceName, methodName)
      |
        interfaceName = "Decoder" and
        (
          // signature: func (Decoder).Decode(req *net/http.Request, v interface{}) error
          methodName = "Decode" and
          out.isParameter(1)
        )
      )
      or
      // Structs of package: clevergo.tech/clevergo@v0.5.2
      exists(string structName, string fields, DataFlow::Field fld |
        this = fld.getARead() and
        fld.hasQualifiedName(packagePath(), structName, fields)
      |
        structName = "Context" and
        fields = "Params"
        or
        structName = "Param" and
        fields = ["Key", "Value"]
      )
      or
      // Types of package: clevergo.tech/clevergo@v0.5.2
      exists(ValueEntity v | v.getType().hasQualifiedName(packagePath(), "Params") |
        this = v.getARead()
      )
    }
  }

  /**
   * Models taint-tracking through functions.
   */
  private class TaintTrackingFunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput out;

    TaintTrackingFunctionModels() {
      // Taint-tracking models for package: clevergo.tech/clevergo@v0.5.2
      (
        // signature: func CleanPath(p string) string
        this.hasQualifiedName(packagePath(), "CleanPath") and
        inp.isParameter(0) and
        out.isResult()
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = out
    }
  }

  /**
   * Models taint-tracking through method calls.
   */
  private class TaintTrackingMethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput out;

    TaintTrackingMethodModels() {
      // Taint-tracking models for package: clevergo.tech/clevergo@v0.5.2
      (
        // Receiver type: Application
        // signature: func (*Application).RouteURL(name string, args ...string) (*net/url.URL, error)
        this.hasQualifiedName(packagePath(), "Application", "RouteURL") and
        inp.isParameter(_) and
        out.isResult(0)
        or
        // Receiver type: Context
        // signature: func (*Context).Context() context.Context
        this.hasQualifiedName(packagePath(), "Context", "Context") and
        inp.isReceiver() and
        out.isResult()
        or
        // Receiver type: Params
        // signature: func (Params).String(name string) string
        this.hasQualifiedName(packagePath(), "Params", "String") and
        inp.isReceiver() and
        out.isResult()
        or
        // Receiver interface: Decoder
        // signature: func (Decoder).Decode(req *net/http.Request, v interface{}) error
        this.implements(packagePath(), "Decoder", "Decode") and
        inp.isParameter(0) and
        out.isParameter(1)
        or
        // Receiver interface: Renderer
        // signature: func (Renderer).Render(w io.Writer, name string, data interface{}, c *Context) error
        this.implements(packagePath(), "Renderer", "Render") and
        inp.isParameter(2) and
        out.isParameter(0)
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = out
    }
  }

  /**
   * Models HTTP redirects.
   */
  private class HttpRedirect extends HTTP::Redirect::Range, DataFlow::CallNode {
    string package;
    DataFlow::Node urlNode;

    HttpRedirect() {
      // HTTP redirect models for package: clevergo.tech/clevergo@v0.5.2
      package = packagePath() and
      // Receiver type: Context
      (
        // signature: func (*Context).Redirect(code int, url string) error
        this = any(Method m | m.hasQualifiedName(package, "Context", "Redirect")).getACall() and
        urlNode = this.getArgument(1)
      )
    }

    override DataFlow::Node getUrl() { result = urlNode }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  /**
   * Models HTTP ResponseBody.
   */
  private class HttpResponseBody extends HTTP::ResponseBody::Range {
    string package;
    DataFlow::CallNode bodySetterCall;
    string contentType;

    HttpResponseBody() {
      // HTTP ResponseBody models for package: clevergo.tech/clevergo@v0.5.2
      package = packagePath() and
      (
        // One call sets both body and content-type (which is implicit in the func name).
        // Receiver type: Context
        exists(string methodName, Method m |
          m.hasQualifiedName(package, "Context", methodName) and
          bodySetterCall = m.getACall()
        |
          // signature: func (*Context).Error(code int, msg string) error
          methodName = "Error" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/plain"
          or
          // signature: func (*Context).HTML(code int, html string) error
          methodName = "HTML" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/html"
          or
          // signature: func (*Context).HTMLBlob(code int, bs []byte) error
          methodName = "HTMLBlob" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/html"
          or
          // signature: func (*Context).JSON(code int, data interface{}) error
          methodName = "JSON" and
          this = bodySetterCall.getArgument(1) and
          contentType = "application/json"
          or
          // signature: func (*Context).JSONBlob(code int, bs []byte) error
          methodName = "JSONBlob" and
          this = bodySetterCall.getArgument(1) and
          contentType = "application/json"
          or
          // signature: func (*Context).JSONP(code int, data interface{}) error
          methodName = "JSONP" and
          this = bodySetterCall.getArgument(1) and
          contentType = "application/javascript"
          or
          // signature: func (*Context).JSONPBlob(code int, bs []byte) error
          methodName = "JSONPBlob" and
          this = bodySetterCall.getArgument(1) and
          contentType = "application/javascript"
          or
          // signature: func (*Context).JSONPCallback(code int, callback string, data interface{}) error
          methodName = "JSONPCallback" and
          this = bodySetterCall.getArgument(2) and
          contentType = "application/javascript"
          or
          // signature: func (*Context).JSONPCallbackBlob(code int, callback string, bs []byte) (err error)
          methodName = "JSONPCallbackBlob" and
          this = bodySetterCall.getArgument(2) and
          contentType = "application/javascript"
          or
          // signature: func (*Context).String(code int, s string) error
          methodName = "String" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/plain"
          or
          // signature: func (*Context).StringBlob(code int, bs []byte) error
          methodName = "StringBlob" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/plain"
          or
          // signature: func (*Context).Stringf(code int, format string, a ...interface{}) error
          methodName = "Stringf" and
          this = bodySetterCall.getArgument([1, any(int i | i >= 2)]) and
          contentType = "text/plain"
          or
          // signature: func (*Context).XML(code int, data interface{}) error
          methodName = "XML" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/xml"
          or
          // signature: func (*Context).XMLBlob(code int, bs []byte) error
          methodName = "XMLBlob" and
          this = bodySetterCall.getArgument(1) and
          contentType = "text/xml"
        )
        or
        // One call sets both body and content-type (both are parameters in the func call).
        // Receiver type: Context
        exists(string methodName, Method m |
          m.hasQualifiedName(package, "Context", methodName) and
          bodySetterCall = m.getACall()
        |
          // signature: func (*Context).Blob(code int, contentType string, bs []byte) (err error)
          methodName = "Blob" and
          this = bodySetterCall.getArgument(2) and
          contentType = bodySetterCall.getArgument(1).getStringValue()
          or
          // signature: func (*Context).Emit(code int, contentType string, body string) (err error)
          methodName = "Emit" and
          this = bodySetterCall.getArgument(2) and
          contentType = bodySetterCall.getArgument(1).getStringValue()
        )
        or
        // Two calls, one to set the response body and one to set the content-type.
        // Receiver type: Context
        exists(string methodName, Method m |
          m.hasQualifiedName(package, "Context", methodName) and
          bodySetterCall = m.getACall()
        |
          // signature: func (*Context).Write(data []byte) (int, error)
          methodName = "Write" and
          this = bodySetterCall.getArgument(0)
          or
          // signature: func (*Context).WriteString(data string) (int, error)
          methodName = "WriteString" and
          this = bodySetterCall.getArgument(0)
        ) and
        (
          // Receiver type: Context
          exists(string methodName, Method m, DataFlow::CallNode contentTypeSetterCall |
            m.hasQualifiedName(package, "Context", methodName) and
            contentTypeSetterCall = m.getACall() and
            contentTypeSetterCall.getReceiver().getAPredecessor*() =
              bodySetterCall.getReceiver().getAPredecessor*()
          |
            // signature: func (*Context).SetContentType(v string)
            methodName = "SetContentType" and
            contentType = contentTypeSetterCall.getArgument(0).getStringValue()
          )
          or
          // Receiver type: Context
          exists(string methodName, Method m, DataFlow::CallNode contentTypeSetterCall |
            m.hasQualifiedName(package, "Context", methodName) and
            contentTypeSetterCall = m.getACall() and
            contentTypeSetterCall.getReceiver().getAPredecessor*() =
              bodySetterCall.getReceiver().getAPredecessor*()
          |
            // signature: func (*Context).SetContentTypeHTML()
            methodName = "SetContentTypeHTML" and
            contentType = "text/html"
            or
            // signature: func (*Context).SetContentTypeJSON()
            methodName = "SetContentTypeJSON" and
            contentType = "application/json"
            or
            // signature: func (*Context).SetContentTypeText()
            methodName = "SetContentTypeText" and
            contentType = "text/plain"
            or
            // signature: func (*Context).SetContentTypeXML()
            methodName = "SetContentTypeXML" and
            contentType = "text/xml"
          )
        )
      )
    }

    override string getAContentType() { result = contentType }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }

  /**
   * Models a HTTP header writer model for package: clevergo.tech/clevergo@v0.5.2
   */
  private class HeaderWrite extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
    HeaderWrite() {
      // Receiver type: Context
      // signature: func (*Context).SetHeader(key string, value string)
      this = any(Method m | m.hasQualifiedName(packagePath(), "Context", "SetHeader")).getACall()
    }

    override DataFlow::Node getName() { result = this.getArgument(0) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override HTTP::ResponseWriter getResponseWriter() { none() }
  }
}
