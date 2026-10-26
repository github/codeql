/**
 * Provides classes for working with [@vercel/node](https://www.npmjs.com/package/@vercel/node) Vercel serverless functions.
 */

import javascript
import semmle.javascript.frameworks.HTTP

/**
 * Provides classes for working with [@vercel/node](https://www.npmjs.com/package/@vercel/node) Vercel serverless functions.
 *
 * A Vercel serverless function is a module whose default export is a function
 * taking parameters `(req: VercelRequest, res: VercelResponse)`, where the
 * types are imported from the `@vercel/node` package. The default export may
 * be synchronous or `async`, and the Vercel runtime invokes it for every
 * incoming HTTP request.
 */
module VercelNode {
  /**
   * A Vercel serverless function handler, identified as the default export of a
   * module whose first two parameters are typed as `VercelRequest` and
   * `VercelResponse` from `@vercel/node`.
   *
   * Since `@vercel/node` is commonly imported as a type-only import, handlers
   * are recognized by their TypeScript parameter types. The default-export
   * constraint excludes private helpers or test utilities that share the
   * same signature.
   */
  class RouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    DataFlow::ParameterNode req;
    DataFlow::ParameterNode res;

    RouteHandler() {
      this = any(Module m).getAnExportedValue("default").getAFunctionValue() and
      req = this.getParameter(0) and
      res = this.getParameter(1) and
      req.hasUnderlyingType(["@vercel/node", "@now/node"], ["NowRequest", "VercelRequest"]) and
      res.hasUnderlyingType(["@vercel/node", "@now/node"], ["NowResponse", "VercelResponse"])
    }

    /** Gets the parameter that contains the request object. */
    DataFlow::ParameterNode getRequest() { result = req }

    /** Gets the parameter that contains the response object. */
    DataFlow::ParameterNode getResponse() { result = res }
  }

  /**
   * A Vercel request source, that is, the request parameter of a route handler.
   */
  private class RequestSource extends Http::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() { this = rh.getRequest() }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Vercel response source, that is, the response parameter of a route handler.
   */
  private class ResponseSource extends Http::Servers::ResponseSource {
    RouteHandler rh;

    ResponseSource() { this = rh.getResponse() }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A chained response, such as `res.status(200)`, `res.type('html')`, or `res.set(...)`.
   *
   * These methods return the response object and are commonly chained before `send` or `json`.
   */
  private class ChainedResponseSource extends Http::Servers::ResponseSource {
    RouteHandler rh;

    ChainedResponseSource() {
      exists(ResponseSource src |
        this = src.ref().getAMethodCall(["status", "type", "set"]) and
        rh = src.getRouteHandler()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An access to user-controlled input on a Vercel request.
   *
   * Covers `req.query`, `req.body`, `req.cookies`, and `req.url` (inherited
   * from Node's `IncomingMessage`). Named-header accesses like `req.headers.host`
   * are handled by `RequestHeaderAccess` below.
   */
  private class RequestInputAccess extends Http::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      exists(RequestSource src | rh = src.getRouteHandler() |
        this = src.ref().getAPropertyRead("query") and kind = "parameter"
        or
        this = src.ref().getAPropertyRead("body") and kind = "body"
        or
        this = src.ref().getAPropertyRead("cookies") and kind = "cookie"
        or
        this = src.ref().getAPropertyRead("url") and kind = "url"
      )
      or
      exists(RequestHeaderAccess access | this = access |
        rh = access.getRouteHandler() and
        kind = "header"
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }
  }

  /**
   * An access to a named header on a Vercel request, for example
   * `req.headers.host` or `req.headers.referer`.
   */
  private class RequestHeaderAccess extends Http::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(RequestSource src |
        this = src.ref().getAPropertyRead("headers").getAPropertyRead() and
        rh = src.getRouteHandler()
      )
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * An argument to `res.send(...)`, `res.json(...)`, or `res.jsonp(...)` on a
   * Vercel response, including chained calls such as `res.status(200).json(...)`.
   */
  private class ResponseSendArgument extends Http::ResponseSendArgument {
    RouteHandler rh;

    ResponseSendArgument() {
      exists(Http::Servers::ResponseSource src |
        (src instanceof ResponseSource or src instanceof ChainedResponseSource) and
        this = src.ref().getAMethodCall(["send", "json", "jsonp"]).getArgument(0) and
        rh = src.getRouteHandler()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A call to `res.redirect(...)` on a Vercel response.
   */
  private class RedirectInvocation extends Http::RedirectInvocation, DataFlow::MethodCallNode {
    RouteHandler rh;

    RedirectInvocation() {
      exists(ResponseSource src |
        this = src.ref().getAMethodCall("redirect") and
        rh = src.getRouteHandler()
      )
    }

    override DataFlow::Node getUrlArgument() { result = this.getLastArgument() }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A call to `res.setHeader(name, value)` on a Vercel response.
   */
  private class SetHeader extends Http::ExplicitHeaderDefinition, DataFlow::CallNode {
    RouteHandler rh;

    SetHeader() {
      exists(ResponseSource src |
        this = src.ref().getAMethodCall("setHeader") and
        rh = src.getRouteHandler()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override predicate definesHeaderValue(string headerName, DataFlow::Node headerValue) {
      headerName = this.getArgument(0).getStringValue().toLowerCase() and
      headerValue = this.getArgument(1)
    }

    override DataFlow::Node getNameNode() { result = this.getArgument(0) }
  }
}
