/**
 * Provides modeling for the `HTTPClient` library.
 */

private import ruby
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
class HttpClientRequest extends HTTP::Client::Request::Range {
  API::Node requestNode;
  API::Node connectionNode;
  DataFlow::CallNode requestUse;
  string method;

  HttpClientRequest() {
    connectionNode =
      [
        // One-off requests
        API::getTopLevelMember("HTTPClient"),
        // Conncection re-use
        API::getTopLevelMember("HTTPClient").getInstance()
      ] and
    requestNode = connectionNode.getReturn(method) and
    requestUse = requestNode.getAnImmediateUse() and
    method in [
        "get", "head", "delete", "options", "post", "put", "trace", "get_content", "post_content"
      ] and
    this = requestUse.asExpr().getExpr()
  }

  override DataFlow::Node getAUrlPart() { result = requestUse.getArgument(0) }

  override DataFlow::Node getResponseBody() {
    // The `get_content` and `post_content` methods return the response body as
    // a string. The other methods return a `HTTPClient::Message` object which
    // has various methods that return the response body.
    method in ["get_content", "post_content"] and result = requestUse
    or
    not method in ["get_content", "put_content"] and
    result = requestNode.getAMethodCall(["body", "http_body", "content", "dump"])
  }

  override predicate disablesCertificateValidation(DataFlow::Node disablingNode) {
    // Look for calls to set
    // `c.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE`
    // on an HTTPClient connection object `c`.
    disablingNode =
      connectionNode.getReturn("ssl_config").getReturn("verify_mode=").getAnImmediateUse() and
    disablingNode.(DataFlow::CallNode).getArgument(0) =
      API::getTopLevelMember("OpenSSL").getMember("SSL").getMember("VERIFY_NONE").getAUse()
  }

  override string getFramework() { result = "HTTPClient" }
}
