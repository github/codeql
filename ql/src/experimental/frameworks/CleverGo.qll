/**
 * Provides classes for working with concepts from the [`clevergo.tech/clevergo@v0.5.2`](https://pkg.go.dev/clevergo.tech/clevergo@v0.5.2) package.
 * CodeQL generated from the `CleverGo.json` codemill spec file.
 */

import go

/**
 * Provides classes for working with concepts from the [`clevergo.tech/clevergo@v0.5.2`](https://pkg.go.dev/clevergo.tech/clevergo@v0.5.2) package.
 */
private module CleverGo {
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
          // signature: func (*Context) BasicAuth() (username string, password string, ok bool)
          methodName = "BasicAuth" and
          out.isResult([0, 1])
          or
          // signature: func (*Context) Decode(v interface{}) (err error)
          methodName = "Decode" and
          out.isParameter(0)
          or
          // signature: func (*Context) DefaultQuery(key string, defaultVlue string) string
          methodName = "DefaultQuery" and
          out.isResult()
          or
          // signature: func (*Context) FormValue(key string) string
          methodName = "FormValue" and
          out.isResult()
          or
          // signature: func (*Context) GetHeader(name string) string
          methodName = "GetHeader" and
          out.isResult()
          or
          // signature: func (*Context) PostFormValue(key string) string
          methodName = "PostFormValue" and
          out.isResult()
          or
          // signature: func (*Context) QueryParam(key string) string
          methodName = "QueryParam" and
          out.isResult()
          or
          // signature: func (*Context) QueryParams() net/url.Values
          methodName = "QueryParams" and
          out.isResult()
          or
          // signature: func (*Context) QueryString() string
          methodName = "QueryString" and
          out.isResult()
        )
        or
        receiverName = "Params" and
        (
          // signature: func (Params) String(name string) string
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
          // signature: func (Decoder) Decode(req *net/http.Request, v interface{}) error
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
        // signature: func (*Application) RouteURL(name string, args ...string) (*net/url.URL, error)
        this.hasQualifiedName(packagePath(), "Application", "RouteURL") and
        inp.isParameter(_) and
        out.isResult(0)
        or
        // Receiver type: Context
        // signature: func (*Context) Context() context.Context
        this.hasQualifiedName(packagePath(), "Context", "Context") and
        inp.isReceiver() and
        out.isResult()
        or
        // Receiver type: Params
        // signature: func (Params) String(name string) string
        this.hasQualifiedName(packagePath(), "Params", "String") and
        inp.isReceiver() and
        out.isResult()
        or
        // Receiver interface: Decoder
        // signature: func (Decoder) Decode(req *net/http.Request, v interface{}) error
        this.implements(packagePath(), "Decoder", "Decode") and
        inp.isParameter(0) and
        out.isParameter(1)
        or
        // Receiver interface: Renderer
        // signature: func (Renderer) Render(w io.Writer, name string, data interface{}, c *Context) error
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
        // signature: func (*Context) Redirect(code int, url string) error
        this = any(Method m | m.hasQualifiedName(package, "Context", "Redirect")).getACall() and
        urlNode = this.getArgument(1)
      )
    }

    override DataFlow::Node getUrl() { result = urlNode }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = this.getReceiver() }
  }

  /**
   * Models HTTP ResponseBody where the content-type is static and non-modifiable.
   */
  private class HttpResponseBodyStaticContentType extends HTTP::ResponseBody::Range {
    string contentTypeString;
    DataFlow::Node receiverNode;

    HttpResponseBodyStaticContentType() {
      exists(string package, string receiverName |
        setsBodyAndStaticContentType(package, receiverName, this, contentTypeString, receiverNode)
      )
    }

    override string getAContentType() { result = contentTypeString }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
  }

  // Holds for a call that sets the body; the content-type is implicitly set.
  private predicate setsBodyAndStaticContentType(
    string package, string receiverName, DataFlow::Node bodyNode, string contentTypeString,
    DataFlow::Node receiverNode
  ) {
    exists(string methodName, Method met, DataFlow::CallNode bodySetterCall |
      met.hasQualifiedName(package, receiverName, methodName) and
      bodySetterCall = met.getACall() and
      receiverNode = bodySetterCall.getReceiver()
    |
      package = packagePath() and
      (
        // Receiver type: Context
        receiverName = "Context" and
        (
          // signature: func (*Context) Error(code int, msg string) error
          methodName = "Error" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/plain"
          or
          // signature: func (*Context) HTML(code int, html string) error
          methodName = "HTML" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/html"
          or
          // signature: func (*Context) HTMLBlob(code int, bs []byte) error
          methodName = "HTMLBlob" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/html"
          or
          // signature: func (*Context) JSON(code int, data interface{}) error
          methodName = "JSON" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "application/json"
          or
          // signature: func (*Context) JSONBlob(code int, bs []byte) error
          methodName = "JSONBlob" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "application/json"
          or
          // signature: func (*Context) JSONP(code int, data interface{}) error
          methodName = "JSONP" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "application/javascript"
          or
          // signature: func (*Context) JSONPBlob(code int, bs []byte) error
          methodName = "JSONPBlob" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "application/javascript"
          or
          // signature: func (*Context) JSONPCallback(code int, callback string, data interface{}) error
          methodName = "JSONPCallback" and
          bodyNode = bodySetterCall.getArgument(2) and
          contentTypeString = "application/javascript"
          or
          // signature: func (*Context) JSONPCallbackBlob(code int, callback string, bs []byte) (err error)
          methodName = "JSONPCallbackBlob" and
          bodyNode = bodySetterCall.getArgument(2) and
          contentTypeString = "application/javascript"
          or
          // signature: func (*Context) String(code int, s string) error
          methodName = "String" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/plain"
          or
          // signature: func (*Context) StringBlob(code int, bs []byte) error
          methodName = "StringBlob" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/plain"
          or
          // signature: func (*Context) Stringf(code int, format string, a ...interface{}) error
          methodName = "Stringf" and
          bodyNode = bodySetterCall.getArgument([1, any(int i | i >= 2)]) and
          contentTypeString = "text/plain"
          or
          // signature: func (*Context) XML(code int, data interface{}) error
          methodName = "XML" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/xml"
          or
          // signature: func (*Context) XMLBlob(code int, bs []byte) error
          methodName = "XMLBlob" and
          bodyNode = bodySetterCall.getArgument(1) and
          contentTypeString = "text/xml"
        )
      )
    )
  }

  /**
   * Models HTTP ResponseBody where the content-type can be dynamically set by the caller.
   */
  private class HttpResponseBodyDynamicContentType extends HTTP::ResponseBody::Range {
    DataFlow::Node contentTypeNode;
    DataFlow::Node receiverNode;

    HttpResponseBodyDynamicContentType() {
      exists(string package, string receiverName |
        setsBodyAndDynamicContentType(package, receiverName, this, contentTypeNode, receiverNode)
      )
    }

    override DataFlow::Node getAContentTypeNode() { result = contentTypeNode }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
  }

  // Holds for a call that sets the body; the content-type is a parameter.
  // Both body and content-type are parameters in the same func call.
  private predicate setsBodyAndDynamicContentType(
    string package, string receiverName, DataFlow::Node bodyNode, DataFlow::Node contentTypeNode,
    DataFlow::Node receiverNode
  ) {
    exists(string methodName, Method met, DataFlow::CallNode bodySetterCall |
      met.hasQualifiedName(package, receiverName, methodName) and
      bodySetterCall = met.getACall() and
      receiverNode = bodySetterCall.getReceiver()
    |
      package = packagePath() and
      (
        // Receiver type: Context
        receiverName = "Context" and
        (
          // signature: func (*Context) Blob(code int, contentType string, bs []byte) (err error)
          methodName = "Blob" and
          bodyNode = bodySetterCall.getArgument(2) and
          contentTypeNode = bodySetterCall.getArgument(1)
          or
          // signature: func (*Context) Emit(code int, contentType string, body string) (err error)
          methodName = "Emit" and
          bodyNode = bodySetterCall.getArgument(2) and
          contentTypeNode = bodySetterCall.getArgument(1)
        )
      )
    )
  }

  /**
   * Models HTTP ResponseBody where only the body is set.
   */
  private class HttpResponseBodyNoContentType extends HTTP::ResponseBody::Range {
    DataFlow::Node receiverNode;

    HttpResponseBodyNoContentType() {
      exists(string package, string receiverName |
        setsBody(package, receiverName, receiverNode, this)
      )
    }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
  }

  // Holds for a call that sets the body. The content-type is not defined.
  private predicate setsBody(
    string package, string receiverName, DataFlow::Node receiverNode, DataFlow::Node bodyNode
  ) {
    exists(string methodName, Method met, DataFlow::CallNode bodySetterCall |
      met.hasQualifiedName(package, receiverName, methodName) and
      bodySetterCall = met.getACall() and
      receiverNode = bodySetterCall.getReceiver()
    |
      package = packagePath() and
      (
        // Receiver type: Context
        receiverName = "Context" and
        (
          // signature: func (*Context) Write(data []byte) (int, error)
          methodName = "Write" and
          bodyNode = bodySetterCall.getArgument(0)
          or
          // signature: func (*Context) WriteString(data string) (int, error)
          methodName = "WriteString" and
          bodyNode = bodySetterCall.getArgument(0)
        )
      )
    )
  }

  /**
   * Models HTTP header writers.
   * The write is done with a call where you can set both the key and the value of the header.
   */
  private class HeaderWrite extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
    DataFlow::Node receiverNode;
    DataFlow::Node headerNameNode;
    DataFlow::Node headerValueNode;

    HeaderWrite() {
      setsHeaderDynamicKeyValue(_, _, this, headerNameNode, headerValueNode, receiverNode)
    }

    override DataFlow::Node getName() { result = headerNameNode }

    override DataFlow::Node getValue() { result = headerValueNode }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
  }

  // Holds for a call that sets a header with a key-value combination.
  private predicate setsHeaderDynamicKeyValue(
    string package, string receiverName, DataFlow::CallNode headerSetterCall,
    DataFlow::Node headerNameNode, DataFlow::Node headerValueNode, DataFlow::Node receiverNode
  ) {
    exists(string methodName, Method met |
      met.hasQualifiedName(package, receiverName, methodName) and
      headerSetterCall = met.getACall() and
      receiverNode = headerSetterCall.getReceiver()
    |
      package = packagePath() and
      (
        // Receiver type: Context
        receiverName = "Context" and
        (
          // signature: func (*Context) SetHeader(key string, value string)
          methodName = "SetHeader" and
          headerNameNode = headerSetterCall.getArgument(0) and
          headerValueNode = headerSetterCall.getArgument(1)
        )
      )
    )
  }

  /**
   * Models an HTTP static content-type header setter.
   */
  private class StaticContentTypeHeaderSetter extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
    DataFlow::Node receiverNode;
    string valueString;

    StaticContentTypeHeaderSetter() {
      setsStaticHeaderContentType(_, _, this, valueString, receiverNode)
    }

    override string getHeaderName() { result = "content-type" }

    override string getHeaderValue() { result = valueString }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { none() }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
  }

  // Holds for a call that sets the content-type header (implicit).
  private predicate setsStaticHeaderContentType(
    string package, string receiverName, DataFlow::CallNode setterCall, string valueString,
    DataFlow::Node receiverNode
  ) {
    exists(string methodName, Method met |
      met.hasQualifiedName(package, receiverName, methodName) and
      setterCall = met.getACall() and
      receiverNode = setterCall.getReceiver()
    |
      package = packagePath() and
      (
        // Receiver type: Context
        receiverName = "Context" and
        (
          // signature: func (*Context) SetContentTypeHTML()
          methodName = "SetContentTypeHTML" and
          valueString = "text/html"
          or
          // signature: func (*Context) SetContentTypeJSON()
          methodName = "SetContentTypeJSON" and
          valueString = "application/json"
          or
          // signature: func (*Context) SetContentTypeText()
          methodName = "SetContentTypeText" and
          valueString = "text/plain"
          or
          // signature: func (*Context) SetContentTypeXML()
          methodName = "SetContentTypeXML" and
          valueString = "text/xml"
        )
      )
    )
  }

  /**
   * Models an HTTP dynamic content-type header setter.
   */
  private class DynamicContentTypeHeaderSetter extends HTTP::HeaderWrite::Range, DataFlow::CallNode {
    DataFlow::Node receiverNode;
    DataFlow::Node valueNode;

    DynamicContentTypeHeaderSetter() {
      setsDynamicHeaderContentType(_, _, this, valueNode, receiverNode)
    }

    override string getHeaderName() { result = "content-type" }

    override DataFlow::Node getName() { none() }

    override DataFlow::Node getValue() { result = valueNode }

    override HTTP::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
  }

  // Holds for a call that sets the content-type header via a parameter.
  private predicate setsDynamicHeaderContentType(
    string package, string receiverName, DataFlow::CallNode setterCall, DataFlow::Node valueNode,
    DataFlow::Node receiverNode
  ) {
    exists(string methodName, Method met |
      met.hasQualifiedName(package, receiverName, methodName) and
      setterCall = met.getACall() and
      receiverNode = setterCall.getReceiver()
    |
      package = packagePath() and
      (
        // Receiver type: Context
        receiverName = "Context" and
        (
          // signature: func (*Context) SetContentType(v string)
          methodName = "SetContentType" and
          valueNode = setterCall.getArgument(0)
        )
      )
    )
  }
}
