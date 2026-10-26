/**
 * Provides classes for working with [Koa](https://koajs.com) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP

module Koa {
  /**
   * An expression that creates a new Koa application.
   */
  class AppDefinition extends Http::Servers::StandardServerDefinition, DataFlow::InvokeNode {
    AppDefinition() {
      // `app = new Koa()` / `app = Koa()`
      this = DataFlow::moduleImport("koa").getAnInvocation()
    }
  }

  /**
   * An HTTP header defined in a Koa application.
   */
  private class HeaderDefinition extends Http::Servers::StandardHeaderDefinition {
    RouteHandler rh;

    HeaderDefinition() {
      // ctx.set('Cache-Control', 'no-cache');
      this.calls(rh.getAResponseOrContextNode(), "set")
      or
      // ctx.response.header('Cache-Control', 'no-cache')
      this.calls(rh.getAResponseNode(), "header")
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Koa route handler.
   */
  abstract class RouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::SourceNode {
    /**
     * Gets the parameter of the route handler that contains the context object.
     */
    DataFlow::ParameterNode getContextParameter() {
      result = this.getAFunctionValue().getParameter(0)
    }

    /**
     * Gets an expression that contains the "context" object of
     * a route handler invocation.
     *
     * Explanation: the context-object in Koa is typically
     * `this` or `ctx`, given as the first and only argument to the
     * route handler.
     */
    DataFlow::Node getAContextNode() { result.(ContextNode).getRouteHandler() = this }

    /**
     * Gets an expression that contains the context or response
     * object of a route handler invocation.
     */
    DataFlow::Node getAResponseOrContextNode() {
      result = this.getAResponseNode() or result = this.getAContextNode()
    }

    /**
     * Gets an expression that contains the context or request
     * object of a route handler invocation.
     */
    DataFlow::Node getARequestOrContextNode() {
      result = this.getARequestNode() or result = this.getAContextNode()
    }

    /**
     * Gets a reference to a request parameter defined by this route handler.
     */
    DataFlow::Node getARequestParameterAccess() {
      none() // overridden in subclasses.
    }

    /**
     * Gets a dataflow node that can be given to a `RouteSetup` to register the handler.
     */
    abstract DataFlow::SourceNode getARouteHandlerRegistrationObject();
  }

  /**
   * A koa route handler registered directly with a route-setup.
   * Like:
   * ```JavaScript
   * var route = require('koa-route');
   * var app = new Koa();
   * app.use((context, next) => {
   *     ...
   * });
   * ```
   */
  private class StandardRouteHandler extends RouteHandler {
    StandardRouteHandler() { any(RouteSetup setup).getARouteHandler() = this }

    override DataFlow::SourceNode getARouteHandlerRegistrationObject() { result = this }
  }

  /**
   * A Koa context source, that is, the context parameter of a
   * route handler, or a `this` access in a route handler.
   */
  private class ContextSource extends DataFlow::Node {
    RouteHandler rh;

    ContextSource() {
      this = rh.getContextParameter()
      or
      this.(DataFlow::ThisNode).getBinder() = rh
    }

    /**
     * Gets the route handler that handles this request.
     */
    RouteHandler getRouteHandler() { result = rh }

    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and
      result = this
      or
      exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
    }

    /** Gets a source node that refers to this context object. */
    DataFlow::SourceNode ref() { result = this.ref(DataFlow::TypeTracker::end()) }
  }

  /**
   * A Koa route handler registered using a routing library.
   *
   * Example of what that could look like:
   * ```JavaScript
   * const router = require('koa-router')();
   * const Koa = require('koa');
   * const app = new Koa();
   * router.get('/', async (ctx, next) => {
   *    // route handler stuff
   * });
   * app.use(router.routes());
   * ```
   */
  private class RoutedRouteHandler extends RouteHandler {
    DataFlow::InvokeNode router;
    DataFlow::MethodCallNode call;

    RoutedRouteHandler() {
      router = DataFlow::moduleImport(["@koa/router", "koa-router"]).getAnInvocation() and
      call =
        router
            .getAChainedMethodCall([
                "use", "get", "post", "put", "link", "unlink", "delete", "del", "head", "options",
                "patch", "all"
              ]) and
      this.flowsTo(call.getArgument(any(int i | i >= 1)))
    }

    override DataFlow::SourceNode getARouteHandlerRegistrationObject() {
      result = call
      or
      result = router.getAMethodCall("routes")
    }
  }

  /**
   * A route handler registered using the `koa-route` library.
   *
   * Example of how `koa-route` can be used:
   * ```JavaScript
   * var route = require('koa-route');
   * var Koa = require('koa');
   * var app = new Koa();
   *
   * app.use(route.get('/pets', (context, param1, param2, param3, ...params) => {
   *    // route handler stuff
   * }));
   */
  class KoaRouteHandler extends RouteHandler {
    DataFlow::CallNode call;

    KoaRouteHandler() {
      call =
        DataFlow::moduleMember("koa-route",
          [
            "all", "acl", "bind", "checkout", "connect", "copy", "delete", "del", "get", "head",
            "link", "lock", "msearch", "merge", "mkactivity", "mkcalendar", "mkcol", "move",
            "notify", "options", "patch", "post", "propfind", "proppatch", "purge", "put", "rebind",
            "report", "search", "subscribe", "trace", "unbind", "unlink", "unlock", "unsubscribe"
          ]).getACall() and
      this.flowsTo(call.getArgument(1))
    }

    override DataFlow::Node getARequestParameterAccess() {
      result = call.getABoundCallbackParameter(1, any(int i | i >= 1))
    }

    override DataFlow::SourceNode getARouteHandlerRegistrationObject() { result = call }
  }

  /**
   * A Koa request source, that is, an access to the `request` property
   * of a context object.
   */
  private class RequestSource extends Http::Servers::RequestSource instanceof DataFlow::PropRead {
    ContextNode ctx;

    RequestSource() { super.accesses(ctx, "request") }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = ctx.getRouteHandler() }
  }

  /**
   * A Koa request source, accessed through the a request property of a
   * generator route handler (deprecated in Koa 3).
   */
  private class GeneratorRequestSource extends Http::Servers::RequestSource {
    RouteHandler rh;

    GeneratorRequestSource() {
      exists(DataFlow::FunctionNode fun | fun = rh |
        fun.getFunction().isGenerator() and
        fun.getReceiver().getAPropertyRead("request") = this
      )
    }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Koa response source, that is, an access to the `response` property
   * of a context object.
   */
  private class ResponseSource extends Http::Servers::ResponseSource instanceof DataFlow::PropRead {
    ContextNode ctx;

    ResponseSource() { super.accesses(ctx, "response") }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = ctx.getRouteHandler() }
  }

  /**
   * An expression that may hold a Koa context object.
   */
  class ContextNode extends DataFlow::Node {
    ContextSource src;

    ContextNode() { src.ref().flowsTo(this) }

    /**
     * Gets the route handler that provides this response.
     */
    RouteHandler getRouteHandler() { result = src.getRouteHandler() }
  }

  /**
   * An expression that may hold a Koa request object.
   */
  class RequestNode extends Http::Servers::StandardRequestNode {
    override RequestSource src;
  }

  /**
   * An expression that may hold a Koa response object.
   */
  class ResponseNode extends Http::Servers::StandardResponseNode {
    override ResponseSource src;
  }

  /**
   * An access to a user-controlled Koa request input.
   */
  private class RequestInputAccess extends Http::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      kind = "parameter" and
      this = getAQueryParameterAccess(rh)
      or
      kind = "parameter" and
      this = rh.getARequestParameterAccess()
      or
      exists(DataFlow::Node e | rh.getARequestOrContextNode() = e |
        // `ctx.request.url`, `ctx.request.originalUrl`, or `ctx.request.href`
        exists(string propName |
          kind = "url" and
          this.(DataFlow::PropRead).accesses(e, propName)
        |
          propName = "url"
          or
          propName = "originalUrl"
          or
          propName = "href"
        )
        or
        // params, when handler is registered by `koa-router` or similar.
        kind = "parameter" and
        this.(DataFlow::PropRead).accesses(e, "params")
        or
        // `ctx.request.body`
        e instanceof RequestNode and
        kind = "body" and
        this.(DataFlow::PropRead).accesses(e, "body")
        or
        // `ctx.cookies.get(<name>)`
        exists(DataFlow::PropRead cookies |
          e instanceof ContextNode and
          kind = "cookie" and
          cookies.accesses(e, "cookies") and
          this = cookies.getAMethodCall("get")
        )
        or
        exists(RequestHeaderAccess access | access = this |
          rh = access.getRouteHandler() and
          kind = "header"
        )
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }

    override predicate isUserControlledObject() { this = getAQueryParameterAccess(rh) }
  }

  private DataFlow::Node getAQueryParameterAccess(RouteHandler rh) {
    // `ctx.query.name` or `ctx.request.query.name`
    exists(DataFlow::PropRead q |
      q.accesses(rh.getARequestOrContextNode(), "query") and
      result = q.getAPropertyRead()
    )
  }

  /**
   * An access to an HTTP header on a Koa request.
   */
  private class RequestHeaderAccess extends Http::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(DataFlow::Node e | e = rh.getARequestOrContextNode() |
        exists(string propName, DataFlow::PropRead headers |
          // `ctx.request.header.<name>`, `ctx.request.headers.<name>`
          headers.accesses(e, propName) and
          this = headers.getAPropertyRead()
        |
          propName = "header" or
          propName = "headers"
        )
        or
        // `ctx.request.get(<name>)`
        this.(DataFlow::MethodCallNode).calls(e, "get")
      )
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
      or
      exists(string name |
        this.(DataFlow::CallNode).getArgument(0).mayHaveStringValue(name) and
        result = name.toLowerCase()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * A call to a Koa method that sets up a route.
   */
  class RouteSetup extends Http::Servers::StandardRouteSetup, DataFlow::MethodCallNode {
    AppDefinition server;

    RouteSetup() {
      // app.use(fun)
      server.ref().getAMethodCall("use") = this
    }

    override DataFlow::SourceNode getARouteHandler() {
      // `StandardRouteHandler` uses this predicate in it's charpred, so making this predicate return a `RouteHandler` would give an empty recursion.
      result.flowsTo(this.getArgument(0))
      or
      // For the route-handlers that does not depend on this predicate in their charpred.
      result.(RouteHandler).getARouteHandlerRegistrationObject().flowsTo(this.getArgument(0))
    }

    override DataFlow::Node getServer() { result = server }
  }

  /**
   * A value assigned to the body of an HTTP response object.
   */
  private class ResponseSendArgument extends Http::ResponseSendArgument {
    RouteHandler rh;

    ResponseSendArgument() {
      exists(DataFlow::PropWrite pwn | pwn.writes(rh.getAResponseOrContextNode(), "body", this))
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends Http::RedirectInvocation instanceof DataFlow::MethodCallNode
  {
    RouteHandler rh;

    RedirectInvocation() { super.calls(rh.getAResponseOrContextNode(), "redirect") }

    override DataFlow::Node getUrlArgument() { result = this.getArgument(0) }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A call to `ctx.render('file', { ... })`, seen as a template instantiation.
   */
  private class RenderCall extends Templating::TemplateInstantiation::Range, DataFlow::CallNode {
    ContextSource ctx;

    RenderCall() { this = ctx.ref().getAMethodCall("render") }

    override DataFlow::SourceNode getOutput() { none() }

    override DataFlow::Node getTemplateFileNode() { result = this.getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() {
      result = this.getArgument(1)
      or
      result = ctx.ref().getAPropertyReference("state")
    }
  }
}
