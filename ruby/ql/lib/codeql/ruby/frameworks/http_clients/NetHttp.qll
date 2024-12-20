/**
 * Provides modeling for the `Net::HTTP` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.internal.DataFlowPublic
private import codeql.ruby.DataFlow

/**
 * A `Net::HTTP` call which initiates an HTTP request.
 * ```ruby
 * Net::HTTP.get("http://example.com/")
 * Net::HTTP.post("http://example.com/", "some_data")
 * req = Net::HTTP.new("example.com")
 * response = req.get("/")
 * ```
 */
class NetHttpRequest extends Http::Client::Request::Range, DataFlow::CallNode {
  private DataFlow::CallNode request;
  private API::Node requestNode;
  private boolean returnsResponseBody;

  NetHttpRequest() {
    exists(string method |
      request = requestNode.asSource() and
      this = request
    |
      // Net::HTTP.get(...)
      method in ["get", "get_response"] and
      requestNode = API::getTopLevelMember("Net").getMember("HTTP").getReturn(method) and
      returnsResponseBody = true
      or
      // Net::HTTP.post(...).body
      method in ["post", "post_form"] and
      requestNode = API::getTopLevelMember("Net").getMember("HTTP").getReturn(method) and
      returnsResponseBody = false
      or
      // Net::HTTP.new(..).get(..).body
      method in [
          "get", "get2", "request_get", "head", "head2", "request_head", "delete", "put", "patch",
          "post", "post2", "request_post", "request"
        ] and
      requestNode = API::getTopLevelMember("Net").getMember("HTTP").getInstance().getReturn(method) and
      returnsResponseBody = false
    )
  }

  /**
   * Gets a node that contributes to the URL of the request.
   */
  override DataFlow::Node getAUrlPart() {
    result = request.getArgument(0)
    or
    // Net::HTTP.new(...).get(...)
    exists(API::Node new |
      new = API::getTopLevelMember("Net").getMember("HTTP").getInstance() and
      requestNode = new.getReturn(_)
    |
      result = new.asSource().(DataFlow::CallNode).getArgument(0)
    )
  }

  override DataFlow::Node getResponseBody() {
    if returnsResponseBody = true
    then result = this
    else result = requestNode.getAMethodCall(["body", "read_body", "entity"])
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    // A Net::HTTP request bypasses certificate validation if we see a setter
    // call like this:
    //   foo.verify_mode = OpenSSL::SSL::VERIFY_NONE
    // and then the receiver of that call flows to the receiver in the request:
    //   foo.request(...)
    exists(DataFlow::CallNode setter |
      setter.asExpr().getExpr().(SetterMethodCall).getMethodName() = "verify_mode=" and
      result = setter.getArgument(0) and
      localFlow(setter.getReceiver(), request.getReceiver())
    )
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    NetHttpDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "Net::HTTP" }
}

/** A configuration to track values that can disable certificate validation for NetHttp. */
private module NetHttpDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").asSource()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(NetHttpRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module NetHttpDisablesCertificateValidationFlow =
  DataFlow::Global<NetHttpDisablesCertificateValidationConfig>;
