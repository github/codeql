/**
 * Provides modeling for the `Request` component of the `Rack` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

/**
 * Provides modeling for the `Request` component of the `Rack` library.
 */
module Request {
  private class RackRequest extends API::Node {
    RackRequest() { this = API::getTopLevelMember("Rack").getMember("Request").getInstance() }
  }

  /** An access to the parameters of a request to a rack application via a `Rack::Request` instance. */
  private class RackRequestParamsAccess extends Http::Server::RequestInputAccess::Range {
    RackRequestParamsAccess() {
      this = any(RackRequest req).getAMethodCall(["params", "query_string", "[]", "fullpath"])
    }

    override string getSourceType() { result = "Rack::Request#params" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }

  /** An access to the cookies of a request to a rack application via a `Rack::Request` instance. */
  private class RackRequestCookiesAccess extends Http::Server::RequestInputAccess::Range {
    RackRequestCookiesAccess() { this = any(RackRequest req).getAMethodCall("cookies") }

    override string getSourceType() { result = "Rack::Request#cookies" }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::cookieInputKind() }
  }
}
