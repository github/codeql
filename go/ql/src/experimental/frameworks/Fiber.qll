/**
 * Provides classes for working with concepts from the following packages:
 * - [`github.com/gofiber/fiber@v1.14.6`](https://pkg.go.dev/github.com/gofiber/fiber@v1.14.6)
 * - [`github.com/gofiber/utils@v0.1.0`](https://pkg.go.dev/github.com/gofiber/utils@v0.1.0)
 *
 * Generated with `Fiber.json` spec.
 */

import go

/**
 * Provides classes for working with concepts from the following packages:
 * - [`github.com/gofiber/fiber@v1.14.6`](https://pkg.go.dev/github.com/gofiber/fiber@v1.14.6)
 * - [`github.com/gofiber/utils@v0.1.0`](https://pkg.go.dev/github.com/gofiber/utils@v0.1.0)
 */
private module Fiber {
  string fiberPackagePath() { result = package("github.com/gofiber/fiber", "") }

  string utilsPackagePath() { result = package("github.com/gofiber/utils", "") }

  /**
   * Models taint-tracking through functions.
   */
  private class TaintTrackingFunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput out;

    TaintTrackingFunctionModels() {
      // Taint-tracking models for package: github.com/gofiber/fiber@v1.14.6
      // signature: func NewError(code int, message ...string) *Error
      this.hasQualifiedName(fiberPackagePath(), "NewError") and
      inp.isParameter(any(int i | i >= 1)) and
      out.isResult()
      or
      // Taint-tracking models for package: github.com/gofiber/utils@v0.1.0
      (
        // signature: func GetBytes(s string) []byte
        this.hasQualifiedName(utilsPackagePath(), "GetBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func GetString(b []byte) string
        this.hasQualifiedName(utilsPackagePath(), "GetString") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func ImmutableString(s string) string
        this.hasQualifiedName(utilsPackagePath(), "ImmutableString") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func SafeBytes(b []byte) []byte
        this.hasQualifiedName(utilsPackagePath(), "SafeBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func SafeString(s string) string
        this.hasQualifiedName(utilsPackagePath(), "SafeString") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func ToLower(b string) string
        this.hasQualifiedName(utilsPackagePath(), "ToLower") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func ToLowerBytes(b []byte) []byte
        this.hasQualifiedName(utilsPackagePath(), "ToLowerBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func ToUpper(b string) string
        this.hasQualifiedName(utilsPackagePath(), "ToUpper") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func ToUpperBytes(b []byte) []byte
        this.hasQualifiedName(utilsPackagePath(), "ToUpperBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func Trim(s string, cutset byte) string
        this.hasQualifiedName(utilsPackagePath(), "Trim") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func TrimBytes(b []byte, cutset byte) []byte
        this.hasQualifiedName(utilsPackagePath(), "TrimBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func TrimLeft(s string, cutset byte) string
        this.hasQualifiedName(utilsPackagePath(), "TrimLeft") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func TrimLeftBytes(b []byte, cutset byte) []byte
        this.hasQualifiedName(utilsPackagePath(), "TrimLeftBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func TrimRight(s string, cutset byte) string
        this.hasQualifiedName(utilsPackagePath(), "TrimRight") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func TrimRightBytes(b []byte, cutset byte) []byte
        this.hasQualifiedName(utilsPackagePath(), "TrimRightBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func UnsafeBytes(s string) (bs []byte)
        this.hasQualifiedName(utilsPackagePath(), "UnsafeBytes") and
        inp.isParameter(0) and
        out.isResult()
        or
        // signature: func UnsafeString(b []byte) string
        this.hasQualifiedName(utilsPackagePath(), "UnsafeString") and
        inp.isParameter(0) and
        out.isResult()
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = out
    }
  }

  /**
   * Models HTTP header writers.
   * The write is done with a call where you can set both the key and the value of the header.
   */
  private class HeaderWrite extends Http::HeaderWrite::Range, DataFlow::CallNode {
    DataFlow::Node receiverNode;
    DataFlow::Node headerNameNode;
    DataFlow::Node headerValueNode;

    HeaderWrite() {
      setsHeaderDynamicKeyValue(_, _, this, headerNameNode, headerValueNode, receiverNode)
    }

    override DataFlow::Node getName() { result = headerNameNode }

    override DataFlow::Node getValue() { result = headerValueNode }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
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
      package = fiberPackagePath() and
      (
        // Receiver type: Ctx
        receiverName = "Ctx" and
        (
          // signature: func (*Ctx) Append(field string, values ...string)
          methodName = "Append" and
          headerNameNode = headerSetterCall.getArgument(0) and
          headerValueNode = headerSetterCall.getSyntacticArgument(any(int i | i >= 1))
          or
          // signature: func (*Ctx) Set(key string, val string)
          methodName = "Set" and
          headerNameNode = headerSetterCall.getArgument(0) and
          headerValueNode = headerSetterCall.getArgument(1)
        )
      )
    )
  }

  /**
   * Models HTTP ResponseBody where the content-type is static and non-modifiable.
   */
  private class ResponseBodyStaticContentType extends Http::ResponseBody::Range {
    string contentTypeString;
    DataFlow::Node receiverNode;

    ResponseBodyStaticContentType() {
      setsBodyAndStaticContentType(_, _, this, contentTypeString, receiverNode)
    }

    override string getAContentType() { result = contentTypeString }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
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
      package = fiberPackagePath() and
      (
        // Receiver type: Ctx
        receiverName = "Ctx" and
        (
          // signature: func (*Ctx) JSON(data interface{}) error
          methodName = "JSON" and
          bodyNode = bodySetterCall.getArgument(0) and
          contentTypeString = "application/json"
          or
          // signature: func (*Ctx) JSONP(data interface{}, callback ...string) error
          methodName = "JSONP" and
          bodyNode = bodySetterCall.getArgument(0) and
          contentTypeString = "application/javascript"
        )
      )
    )
  }

  /**
   * Models HTTP ResponseBody where only the body is set.
   */
  private class ResponseBodyNoContentType extends Http::ResponseBody::Range {
    DataFlow::Node receiverNode;

    ResponseBodyNoContentType() { setsBody(_, _, receiverNode, this) }

    override Http::ResponseWriter getResponseWriter() { result.getANode() = receiverNode }
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
      package = fiberPackagePath() and
      (
        // Receiver type: Ctx
        receiverName = "Ctx" and
        (
          // signature: func (*Ctx) Format(body interface{})
          methodName = "Format" and
          bodyNode = bodySetterCall.getArgument(0)
          or
          // signature: func (*Ctx) Send(bodies ...interface{})
          methodName = "Send" and
          bodyNode = bodySetterCall.getASyntacticArgument()
          or
          // signature: func (*Ctx) SendBytes(body []byte)
          methodName = "SendBytes" and
          bodyNode = bodySetterCall.getArgument(0)
          or
          // signature: func (*Ctx) SendStream(stream io.Reader, size ...int)
          methodName = "SendStream" and
          bodyNode = bodySetterCall.getArgument(0)
          or
          // signature: func (*Ctx) SendString(body string)
          methodName = "SendString" and
          bodyNode = bodySetterCall.getArgument(0)
          or
          // signature: func (*Ctx) Write(bodies ...interface{})
          methodName = "Write" and
          bodyNode = bodySetterCall.getASyntacticArgument()
        )
      )
    )
  }

  /**
   * Provides models of remote flow sources.
   */
  private class RemoteFlowSources extends RemoteFlowSource::Range {
    RemoteFlowSources() {
      // Methods on types of package: github.com/gofiber/fiber@v1.14.6
      exists(string receiverName, string methodName, Method mtd, FunctionOutput out |
        this = out.getExitNode(mtd.getACall()) and
        mtd.hasQualifiedName(fiberPackagePath(), receiverName, methodName)
      |
        receiverName = "Ctx" and
        (
          // signature: func (*Ctx) BaseURL() string
          methodName = "BaseURL" and
          out.isResult()
          or
          // signature: func (*Ctx) Body() string
          methodName = "Body" and
          out.isResult()
          or
          // signature: func (*Ctx) BodyParser(out interface{}) error
          methodName = "BodyParser" and
          out.isParameter(0)
          or
          // signature: func (*Ctx) Cookies(key string, defaultValue ...string) string
          methodName = "Cookies" and
          out.isResult()
          or
          // signature: func (*Ctx) FormFile(key string) (*mime/multipart.FileHeader, error)
          methodName = "FormFile" and
          out.isResult(0)
          or
          // signature: func (*Ctx) FormValue(key string) (value string)
          methodName = "FormValue" and
          out.isResult()
          or
          // signature: func (*Ctx) Get(key string, defaultValue ...string) string
          methodName = "Get" and
          out.isResult()
          or
          // signature: func (*Ctx) Hostname() string
          methodName = "Hostname" and
          out.isResult()
          or
          // signature: func (*Ctx) Method(override ...string) string
          methodName = "Method" and
          out.isResult()
          or
          // signature: func (*Ctx) MultipartForm() (*mime/multipart.Form, error)
          methodName = "MultipartForm" and
          out.isResult(0)
          or
          // signature: func (*Ctx) OriginalURL() string
          methodName = "OriginalURL" and
          out.isResult()
          or
          // signature: func (*Ctx) Params(key string, defaultValue ...string) string
          methodName = "Params" and
          out.isResult()
          or
          // signature: func (*Ctx) Path(override ...string) string
          methodName = "Path" and
          out.isResult()
          or
          // signature: func (*Ctx) Query(key string, defaultValue ...string) string
          methodName = "Query" and
          out.isResult()
          or
          // signature: func (*Ctx) QueryParser(out interface{}) error
          methodName = "QueryParser" and
          out.isParameter(0)
          or
          // signature: func (*Ctx) Range(size int) (rangeData Range, err error)
          methodName = "Range" and
          out.isResult(0)
          or
          // signature: func (*Ctx) Subdomains(offset ...int) []string
          methodName = "Subdomains" and
          out.isResult()
        )
      )
      or
      // Structs of package: github.com/gofiber/fiber@v1.14.6
      exists(string structName, string fields, DataFlow::Field fld |
        this = fld.getARead() and
        fld.hasQualifiedName(fiberPackagePath(), structName, fields)
      |
        structName = "Cookie" and
        fields = ["Domain", "Name", "Path", "SameSite", "Value"]
        or
        structName = "Error" and
        fields = "Message"
      )
    }
  }
}
