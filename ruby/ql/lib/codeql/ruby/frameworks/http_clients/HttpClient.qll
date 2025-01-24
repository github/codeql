/**
 * Provides modeling for the `HTTPClient` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * A call that makes an HTTP request using `HTTPClient`.
 * ```ruby
 * HTTPClient.get("http://example.com").body
 * HTTPClient.get_content("http://example.com")
 * ```
 */
class HttpClientRequest extends Http::Client::Request::Range, DataFlow::CallNode {
  API::Node requestNode;
  API::Node connectionNode;
  string method;

  HttpClientRequest() {
    connectionNode =
      [
        // One-off requests
        API::getTopLevelMember("HTTPClient"),
        // Connection re-use
        API::getTopLevelMember("HTTPClient").getInstance()
      ] and
    requestNode = connectionNode.getReturn(method) and
    this = requestNode.asSource() and
    method in [
        "get", "head", "delete", "options", "post", "put", "trace", "get_content", "post_content"
      ]
  }

  override DataFlow::Node getAUrlPart() { result = this.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    // The `get_content` and `post_content` methods return the response body as
    // a string. The other methods return a `HTTPClient::Message` object which
    // has various methods that return the response body.
    method in ["get_content", "post_content"] and result = this
    or
    not method in ["get_content", "put_content"] and
    result = requestNode.getAMethodCall(["body", "http_body", "content", "dump"])
  }

  /** Gets the value that controls certificate validation, if any. */
  DataFlow::Node getCertificateValidationControllingValue() {
    // Look for calls to set
    // `c.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE`
    // on an HTTPClient connection object `c`.
    result =
      connectionNode
          .getReturn("ssl_config")
          .getReturn("verify_mode=")
          .asSource()
          .(DataFlow::CallNode)
          .getArgument(0)
  }

  cached
  override predicate disablesCertificateValidation(
    DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
  ) {
    HttpClientDisablesCertificateValidationFlow::flow(argumentOrigin, disablingNode) and
    disablingNode = this.getCertificateValidationControllingValue()
  }

  override string getFramework() { result = "HTTPClient" }
}

/** A configuration to track values that can disable certificate validation for HttpClient. */
private module HttpClientDisablesCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").asSource()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(HttpClientRequest req).getCertificateValidationControllingValue()
  }

  predicate observeDiffInformedIncrementalMode() {
    none() // Used for a library model
  }
}

private module HttpClientDisablesCertificateValidationFlow =
  DataFlow::Global<HttpClientDisablesCertificateValidationConfig>;
