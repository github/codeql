private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.StandardLibrary

/**
 * A call that makes an HTTP request using `OpenURI`.
 * ```ruby
 * Kernel.open("http://example.com").read
 * URI.open("http://example.com").readlines
 * URI.parse("http://example.com").open.read
 * ```
 */
class OpenURIRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  OpenURIRequest() {
    exists(API::Node requestNode | request = requestNode.getAnImmediateUse() |
      requestNode =
        [API::getTopLevelMember("URI"), API::getTopLevelMember("URI").getReturn("parse")]
            .getReturn("open") and
      responseBody = requestNode.getAMethodCall(["read", "readlines"]) and
      this = request.asExpr().getExpr()
    )
    or
    // Kernel.open("http://example.com").read
    // open("http://example.com").read
    request instanceof KernelMethodCall and
    this.getMethodName() = "open" and
    request.asExpr().getExpr() = this and
    responseBody.asExpr().getExpr().(MethodCall).getMethodName() in ["read", "readlines"] and
    request.(DataFlow::LocalSourceNode).flowsTo(responseBody.getReceiver())
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "OpenURI" }
}
