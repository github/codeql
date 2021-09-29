private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs

/**
 * A call that makes an HTTP request using `HTTParty`.
 * ```ruby
 * # one-off request - returns the response body
 * HTTParty.get("http://example.com")
 *
 * # TODO: module inclusion
 * class MyClass
 *  include HTTParty
 * end
 *
 * MyClass.new("http://example.com")
 * ```
 */
class HttpartyRequest extends HTTP::Client::Request::Range {
  DataFlow::Node request;
  DataFlow::CallNode responseBody;

  HttpartyRequest() {
    exists(API::Node requestNode | request = requestNode.getAnImmediateUse() |
      requestNode =
        API::getTopLevelMember("HTTParty")
            .getReturn(["get", "head", "delete", "options", "post", "put", "patch"]) and
      (
        // If HTTParty can recognise the response type, it will parse and return it
        // directly from the request call. Otherwise, it will return a `HTTParty::Response`
        // object that has a `#body` method.
        // So if there's a call to `#body` on the response, treat that as the response body.
        exists(DataFlow::Node r | r = requestNode.getAMethodCall("body") | responseBody = r)
        or
        // Otherwise, treat the response as the response body.
        not exists(DataFlow::Node r | r = requestNode.getAMethodCall("body")) and
        responseBody = request
      ) and
      this = request.asExpr().getExpr()
    )
  }

  override DataFlow::Node getResponseBody() { result = responseBody }

  override string getFramework() { result = "HTTParty" }
}
