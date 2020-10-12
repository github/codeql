/**
 * Provides classes for working with [Express](https://expressjs.com) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.frameworks.ExpressModules
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.frameworks.ConnectExpressShared::ConnectExpressShared

module Express {
  /**
   * Gets a data flow node that corresponds to an expression that creates a new
   * Express application.
   */
  DataFlow::SourceNode appCreation() {
    // `app = [new] express()`
    result = DataFlow::moduleImport("express").getAnInvocation()
    or
    // `app = express.createServer()`
    result = DataFlow::moduleMember("express", "createServer").getAnInvocation()
  }

  /**
   * Gets a data flow node that corresponds to an expression that creates a new
   * Express router (possibly an application).
   */
  DataFlow::SourceNode routerCreation() {
    result = appCreation()
    or
    // `app = [new] express.Router()`
    result = DataFlow::moduleMember("express", "Router").getAnInvocation()
  }

  /**
   * Holds if `e` may refer to the given `router` object.
   */
  private predicate isRouter(Expr e, RouterDefinition router) { router.flowsTo(e) }

  /**
   * Holds if `e` may refer to a router object.
   */
  private predicate isRouter(Expr e) {
    isRouter(e, _)
    or
    e.getType().hasUnderlyingType("express", "Router")
    or
    // created by `webpack-dev-server`
    WebpackDevServer::webpackDevServerApp().flowsToExpr(e)
  }

  /**
   * An expression that refers to a route.
   */
  class RouteExpr extends MethodCallExpr {
    RouteExpr() { isRouter(this) }

    /** Gets the router from which this route was created, if it is known. */
    RouterDefinition getRouter() { isRouter(this, result) }
  }

  /**
   * Gets the name of an Express router method that sets up a route.
   */
  string routeSetupMethodName() {
    result = "param" or
    result = "all" or
    result = "use" or
    result = any(HTTP::RequestMethodName m).toLowerCase() or
    // deprecated methods
    result = "error" or
    result = "del"
  }

  /**
   * A call to an Express router method that sets up a route.
   */
  class RouteSetup extends HTTP::Servers::StandardRouteSetup, MethodCallExpr {
    RouteSetup() {
      isRouter(getReceiver()) and
      getMethodName() = routeSetupMethodName()
    }

    /** Gets the path associated with the route. */
    string getPath() { getArgument(0).mayHaveStringValue(result) }

    /** Gets the router on which handlers are being registered. */
    RouterDefinition getRouter() { isRouter(getReceiver(), result) }

    /** Holds if this is a call `use`, such as `app.use(handler)`. */
    predicate isUseCall() { getMethodName() = "use" }

    /**
     * Gets the `n`th handler registered by this setup, with 0 being the first.
     *
     * This differs from `getARouteHandler` in that the argument expression is
     * returned, not its dataflow source.
     */
    Expr getRouteHandlerExpr(int index) {
      // The first argument is a URI pattern if it is a string. If it could possibly be
      // a function, we consider it to be a route handler, otherwise a URI pattern.
      exists(AnalyzedNode firstArg | firstArg = getArgument(0).analyze() |
        if firstArg.getAType() = TTFunction()
        then result = getArgument(index)
        else (
          index >= 0 and result = getArgument(index + 1)
        )
      )
    }

    /** Gets an argument that represents a route handler being registered. */
    Expr getARouteHandlerExpr() { result = getRouteHandlerExpr(_) }

    /** Gets the last argument representing a route handler being registered. */
    Expr getLastRouteHandlerExpr() { result = max(int i | | getRouteHandlerExpr(i) order by i) }

    override DataFlow::SourceNode getARouteHandler() {
      result = getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = getARouteHandlerExpr().flow().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2, DataFlow::SourceNode succ | succ = getARouteHandler(t2) |
        result = succ.backtrack(t2, t)
        or
        HTTP::routeHandlerStep(result, succ) and
        t = t2
      )
    }

    override Expr getServer() { result.(Application).getARouteHandler() = getARouteHandler() }

    /**
     * Gets the HTTP request type this is registered for, if any.
     *
     * Has no result for `use`, `all`, or `param` calls.
     */
    HTTP::RequestMethodName getRequestMethod() { result.toLowerCase() = getMethodName() }

    /**
     * Holds if this registers a route for all request methods.
     */
    predicate handlesAllRequestMethods() { getMethodName() = ["use", "all", "param"] }

    /**
     * Holds if this route setup sets up a route for the same
     * request method as `that`.
     */
    bindingset[that]
    predicate handlesSameRequestMethodAs(RouteSetup that) {
      this.handlesAllRequestMethods() or
      that.handlesAllRequestMethods() or
      this.getRequestMethod() = that.getRequestMethod()
    }

    /**
     * Holds if this route setup is a parameter handler, such as `app.param("foo", ...)`.
     */
    predicate isParameterHandler() { getMethodName() = "param" }
  }

  /**
   * A call that sets up a Passport router that includes the request object.
   */
  private class PassportRouteSetup extends HTTP::Servers::StandardRouteSetup, CallExpr {
    DataFlow::ModuleImportNode importNode;
    DataFlow::FunctionNode callback;

    // looks for this pattern: passport.use(new Strategy({passReqToCallback: true}, callback))
    PassportRouteSetup() {
      importNode = DataFlow::moduleImport("passport") and
      this = importNode.getAMemberCall("use").asExpr() and
      exists(DataFlow::NewNode strategy |
        strategy.flowsToExpr(this.getArgument(0)) and
        strategy.getNumArgument() = 2 and
        // new Strategy({passReqToCallback: true}, ...)
        strategy.getOptionArgument(0, "passReqToCallback").mayHaveBooleanValue(true) and
        callback.flowsTo(strategy.getArgument(1))
      )
    }

    override Expr getServer() { result = importNode.asExpr() }

    override DataFlow::SourceNode getARouteHandler() { result = callback }
  }

  /**
   * The callback given to passport in PassportRouteSetup.
   */
  private class PassportRouteHandler extends RouteHandler, HTTP::Servers::StandardRouteHandler,
    DataFlow::ValueNode {
    override Function astNode;

    PassportRouteHandler() { this = any(PassportRouteSetup setup).getARouteHandler() }

    override Parameter getRouteHandlerParameter(string kind) {
      kind = "request" and
      result = astNode.getParameter(0)
    }
  }

  /**
   * An expression used as an Express route handler, such as `submitHandler` below:
   * ```
   * app.post('/submit', submitHandler)
   * ```
   *
   * Unlike `RouterHandler`, this is the argument passed to a setup, as opposed to
   * a function that flows into such an argument.
   */
  class RouteHandlerExpr extends Expr {
    RouteSetup setup;
    int index;

    RouteHandlerExpr() { this = setup.getRouteHandlerExpr(index) }

    /**
     * Gets the setup call that registers this route handler.
     */
    RouteSetup getSetup() { result = setup }

    /**
     * Gets the function body of this handler, if it is defined locally.
     */
    RouteHandler getBody() { result.(DataFlow::SourceNode).flowsToExpr(this) }

    /**
     * Holds if this is not followed by more handlers.
     */
    predicate isLastHandler() {
      not setup.isUseCall() and
      not exists(setup.getRouteHandlerExpr(index + 1))
    }

    /**
     * Gets a route handler that immediately precedes this in the route stack.
     *
     * For example:
     * ```
     * app.use(auth);
     * app.get('/foo', parseForm, foo);
     * app.get('/bar', bar);
     * ```
     * The previous from `foo` is `parseForm`, and the previous from `parseForm` is `auth`.
     * The previous from `bar` is `auth`.
     *
     * This does not take URI patterns into account. Route handlers should be seen as a no-ops when the
     * requested URI does not match its pattern, but it will be part of the route stack regardless.
     * For example:
     * ```
     * app.use('/admin', auth);
     * app.get('/foo, 'foo);
     * ```
     * In this case, the previous from `foo` is `auth` although they do not act on the
     * same requests.
     */
    Express::RouteHandlerExpr getPreviousMiddleware() {
      index = 0 and result = setup.getRouter().getMiddlewareStackAt(setup.getAPredecessor())
      or
      index > 0 and result = setup.getRouteHandlerExpr(index - 1)
      or
      // Outside the router's original container, use the flow-insensitive model of its middleware stack.
      // Its state is not tracked to CFG nodes outside its original container.
      index = 0 and
      exists(RouterDefinition router | router = setup.getRouter() |
        router.getContainer() != setup.getContainer() and
        result = router.getMiddlewareStack()
      )
    }

    /**
     * Gets a route handler that may follow immediately after this one in its route stack.
     */
    Express::RouteHandlerExpr getNextMiddleware() { result.getPreviousMiddleware() = this }

    /**
     * Gets a route handler that precedes this one (not necessarily immediately), may handle
     * same request method, and matches on the same path or a prefix.
     *
     * If the preceding handler's path cannot be determined, it is assumed to match.
     *
     * Note that this predicate is not complete: path globs such as `'*'` are not currently
     * handled, and relative paths of subrouters are not modelled. In particular, if an outer
     * router installs a route handler `r1` on a path that matches the path of a route handler
     * `r2` installed on a subrouter, `r1` will not be recognized as an ancestor of `r2`.
     */
    Express::RouteHandlerExpr getAMatchingAncestor() {
      result = getPreviousMiddleware+() and
      exists(RouteSetup resSetup | resSetup = result.getSetup() |
        // check whether request methods are compatible
        resSetup.handlesSameRequestMethodAs(setup) and
        // check whether `resSetup` matches on (a prefix of) the same path as `setup`
        (
          // if `result` doesn't specify a path or we cannot determine it, assume
          // that it matches
          not exists(resSetup.getPath())
          or
          setup.getPath() = resSetup.getPath() + any(string s)
        )
      )
      or
      // if this is a sub-router, any previously installed middleware for the same
      // request method will necessarily match
      exists(RouteHandlerExpr outer |
        setup.getRouter() = outer.getAsSubRouter() and
        outer.getSetup().handlesSameRequestMethodAs(setup) and
        result = outer.getAMatchingAncestor()
      )
    }

    /**
     * Gets the router being registered as a sub-router here, if any.
     */
    RouterDefinition getAsSubRouter() { isRouter(this, result) }
  }

  /**
   * A function used as an Express route handler.
   *
   * By default, only handlers installed by an Express route setup are recognized,
   * but support for other kinds of route handlers can be added by implementing
   * additional subclasses of this class.
   */
  abstract class RouteHandler extends HTTP::RouteHandler {
    /**
     * Gets the parameter of kind `kind` of this route handler.
     *
     * `kind` is one of: "error", "request", "response", "next", or "parameter".
     */
    abstract Parameter getRouteHandlerParameter(string kind);

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    Parameter getRequestParameter() { result = getRouteHandlerParameter("request") }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    Parameter getResponseParameter() { result = getRouteHandlerParameter("response") }

    /**
     * Gets a request body access of this handler.
     */
    Expr getARequestBodyAccess() { result.(PropAccess).accesses(getARequestExpr(), "body") }
  }

  /**
   * An Express route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler, HTTP::Servers::StandardRouteHandler,
    DataFlow::ValueNode {
    override Function astNode;
    RouteSetup routeSetup;

    StandardRouteHandler() { this = routeSetup.getARouteHandler() }

    override Parameter getRouteHandlerParameter(string kind) {
      if routeSetup.isParameterHandler()
      then result = getRouteParameterHandlerParameter(astNode, kind)
      else result = getRouteHandlerParameter(astNode, kind)
    }
  }

  /**
   * Holds if `call` is a chainable method call on the response object of `handler`.
   */
  private predicate isChainableResponseMethodCall(RouteHandler handler, MethodCallExpr call) {
    exists(string name | call.calls(handler.getAResponseExpr(), name) |
      name = "append" or
      name = "attachment" or
      name = "clearCookie" or
      name = "contentType" or
      name = "cookie" or
      name = "format" or
      name = "header" or
      name = "json" or
      name = "jsonp" or
      name = "links" or
      name = "location" or
      name = "send" or
      name = "sendStatus" or
      name = "set" or
      name = "status" or
      name = "type" or
      name = "vary"
    )
  }

  /** An Express response source. */
  abstract private class ResponseSource extends HTTP::Servers::ResponseSource { }

  /**
   * An Express response source, that is, the response parameter of a
   * route handler, or a chained method call on a response.
   */
  private class ExplicitResponseSource extends ResponseSource {
    RouteHandler rh;

    ExplicitResponseSource() {
      this = DataFlow::parameterNode(rh.getResponseParameter())
      or
      isChainableResponseMethodCall(rh, this.asExpr())
    }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An Express response source, based on static type information.
   */
  private class TypedResponseSource extends ResponseSource {
    TypedResponseSource() { hasUnderlyingType("express", "Response") }

    override RouteHandler getRouteHandler() { none() } // Not known.
  }

  /** An Express request source. */
  abstract private class RequestSource extends HTTP::Servers::RequestSource { }

  /**
   * An Express request source, that is, the request parameter of a
   * route handler.
   */
  private class ExplicitRequestSource extends RequestSource {
    RouteHandler rh;

    ExplicitRequestSource() { this = DataFlow::parameterNode(rh.getRequestParameter()) }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An Express request source, based on static type information.
   */
  private class TypedRequestSource extends RequestSource {
    TypedRequestSource() { hasUnderlyingType("express", "Request") }

    override RouteHandler getRouteHandler() { none() } // Not known.
  }

  /**
   * An Express response expression.
   */
  class ResponseExpr extends NodeJSLib::ResponseExpr {
    override ResponseSource src;
  }

  /**
   * An Express request expression.
   */
  class RequestExpr extends NodeJSLib::RequestExpr {
    override RequestSource src;
  }

  /**
   * Gets a reference to the "query" object from a request-object originating from route-handler `rh`.
   */
  DataFlow::SourceNode getAQueryObjectReference(DataFlow::TypeTracker t, RouteHandler rh) {
    t.startInProp("query") and
    result = rh.getARequestSource()
    or
    exists(DataFlow::TypeTracker t2 | result = getAQueryObjectReference(t2, rh).track(t2, t))
  }

  /**
   * Gets a reference to the "params" object from a request-object originating from route-handler `rh`.
   */
  DataFlow::SourceNode getAParamsObjectReference(DataFlow::TypeTracker t, RouteHandler rh) {
    t.startInProp("params") and
    result = rh.getARequestSource()
    or
    exists(DataFlow::TypeTracker t2 | result = getAParamsObjectReference(t2, rh).track(t2, t))
  }

  /**
   * An access to a user-controlled Express request input.
   */
  class RequestInputAccess extends HTTP::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      kind = "parameter" and
      this =
        [getAQueryObjectReference(DataFlow::TypeTracker::end(), rh),
            getAParamsObjectReference(DataFlow::TypeTracker::end(), rh)].getAPropertyRead()
      or
      exists(DataFlow::SourceNode request | request = rh.getARequestSource().ref() |
        kind = "parameter" and
        this = request.getAMethodCall("param")
        or
        // `req.originalUrl`
        kind = "url" and
        this = request.getAPropertyRead("originalUrl")
        or
        // `req.cookies`
        kind = "cookie" and
        this = request.getAPropertyRead("cookies")
        or
        // `req.files`, treated the same as `req.body`.
        kind = "body" and
        this = request.getAPropertyRead("files")
      )
      or
      kind = "body" and
      this.asExpr() = rh.getARequestBodyAccess()
      or
      // `value` in `router.param('foo', (req, res, next, value) => { ... })`
      kind = "parameter" and
      exists(RouteSetup setup | rh = setup.getARouteHandler() |
        this = DataFlow::parameterNode(rh.getRouteHandlerParameter("parameter"))
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }

    override predicate isUserControlledObject() {
      kind = "body" and
      exists(ExpressLibraries::BodyParser bodyParser, RouteHandlerExpr expr |
        expr.getBody() = rh and
        bodyParser.producesUserControlledObjects() and
        bodyParser.flowsToExpr(expr.getAMatchingAncestor())
      )
      or
      // If we can't find the middlewares for the route handler,
      // but all known body parsers are deep, assume req.body is a deep object.
      kind = "body" and
      forall(ExpressLibraries::BodyParser bodyParser | bodyParser.producesUserControlledObjects())
      or
      kind = "parameter" and
      exists(DataFlow::Node request | request = DataFlow::valueNode(rh.getARequestExpr()) |
        this.(DataFlow::MethodCallNode).calls(request, "param")
      )
      or
      // `req.query.name`
      kind = "parameter" and
      this = getAQueryObjectReference(DataFlow::TypeTracker::end(), rh).getAPropertyRead()
    }
  }

  /**
   * An access to a header on an Express request.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(DataFlow::Node request | request = DataFlow::valueNode(rh.getARequestExpr()) |
        exists(string methodName |
          // `req.get(...)` or `req.header(...)`
          this.(DataFlow::MethodCallNode).calls(request, methodName)
        |
          methodName = "get" or
          methodName = "header"
        )
        or
        exists(DataFlow::PropRead headers |
          // `req.headers.name`
          headers.accesses(request, "headers") and
          this = headers.getAPropertyRead()
        )
        or
        exists(string propName | propName = "host" or propName = "hostname" |
          // `req.host` and `req.hostname` are derived from headers
          this.(DataFlow::PropRead).accesses(request, propName)
        )
      )
    }

    override string getAHeaderName() {
      exists(string name |
        name = this.(DataFlow::PropRead).getPropertyName()
        or
        this.(DataFlow::CallNode).getArgument(0).mayHaveStringValue(name)
      |
        if name = "hostname" then result = "host" else result = name.toLowerCase()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * HTTP headers created by Express calls
   */
  abstract private class ExplicitHeader extends HTTP::ExplicitHeaderDefinition {
    Expr response;

    /**
     * Gets the response expression that this header is set on.
     */
    Expr getResponse() { result = response }
  }

  /**
   * Holds if `e` is an HTTP request object.
   */
  predicate isRequest(Expr e) { any(RouteHandler rh).getARequestExpr() = e }

  /**
   * Holds if `e` is an HTTP response object.
   */
  predicate isResponse(Expr e) { any(RouteHandler rh).getAResponseExpr() = e }

  /**
   * An access to the HTTP request body.
   */
  class RequestBodyAccess extends Expr {
    RequestBodyAccess() { any(RouteHandler h).getARequestBodyAccess() = this }
  }

  abstract private class HeaderDefinition extends HTTP::Servers::StandardHeaderDefinition {
    HeaderDefinition() { isResponse(astNode.getReceiver()) }

    override RouteHandler getRouteHandler() { astNode.getReceiver() = result.getAResponseExpr() }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends HTTP::RedirectInvocation, MethodCallExpr {
    RouteHandler rh;

    RedirectInvocation() {
      getReceiver() = rh.getAResponseExpr() and
      getMethodName() = "redirect"
    }

    override Expr getUrlArgument() { result = getLastArgument() }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation of the `set` or `header` method on an HTTP response object that
   * sets a single header.
   */
  private class SetOneHeader extends HeaderDefinition {
    SetOneHeader() {
      astNode.getMethodName() = any(string n | n = "set" or n = "header") and
      astNode.getNumArgument() = 2
    }
  }

  /**
   * An invocation of the `set` or `header` method on an HTTP response object that
   * sets multiple headers.
   */
  class SetMultipleHeaders extends ExplicitHeader, DataFlow::ValueNode {
    override MethodCallExpr astNode;
    RouteHandler rh;

    SetMultipleHeaders() {
      astNode.getReceiver() = rh.getAResponseExpr() and
      response = astNode.getReceiver() and
      astNode.getMethodName() = any(string n | n = "set" or n = "header") and
      astNode.getNumArgument() = 1
    }

    /**
     * Gets a reference to the multiple headers object that is to be set.
     */
    private DataFlow::SourceNode getAHeaderSource() { result.flowsToExpr(astNode.getArgument(0)) }

    override predicate definesExplicitly(string headerName, Expr headerValue) {
      exists(string header |
        getAHeaderSource().hasPropertyWrite(header, DataFlow::valueNode(headerValue)) and
        headerName = header.toLowerCase()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override Expr getNameExpr() {
      exists(DataFlow::PropWrite write |
        getAHeaderSource().flowsTo(write.getBase()) and
        result = write.getPropertyNameExpr()
      )
    }
  }

  /**
   * An invocation of the `append` method on an HTTP response object.
   */
  private class AppendHeader extends HeaderDefinition {
    AppendHeader() { astNode.getMethodName() = "append" }
  }

  /**
   * An argument passed to the `send` or `end` method of an HTTP response object.
   */
  private class ResponseSendArgument extends HTTP::ResponseSendArgument {
    RouteHandler rh;

    ResponseSendArgument() {
      exists(MethodCallExpr mce |
        mce.calls(rh.getAResponseExpr(), "send") and
        this = mce.getArgument(0)
      )
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation of the `cookie` method on an HTTP response object.
   */
  private class SetCookie extends HTTP::CookieDefinition, MethodCallExpr {
    RouteHandler rh;

    SetCookie() { calls(rh.getAResponseExpr(), "cookie") }

    override Expr getNameArgument() { result = getArgument(0) }

    override Expr getValueArgument() { result = getArgument(1) }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An expression passed to the `render` method of an HTTP response object
   * as the value of a template variable.
   */
  private class TemplateInput extends HTTP::ResponseBody {
    RouteHandler rh;

    TemplateInput() {
      exists(DataFlow::MethodCallNode render |
        render.calls(rh.getAResponseExpr().flow(), "render") and
        this = render.getOptionArgument(1, _).asExpr()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An Express server application.
   */
  private class Application extends HTTP::ServerDefinition {
    Application() { this = appCreation().asExpr() }

    /**
     * Gets a route handler of the application, regardless of nesting.
     */
    override HTTP::RouteHandler getARouteHandler() {
      result = this.(RouterDefinition).getASubRouter*().getARouteHandler()
    }
  }

  /**
   * An Express router.
   */
  class RouterDefinition extends InvokeExpr {
    RouterDefinition() { this = routerCreation().asExpr() }

    private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::exprNode(this)
      or
      exists(string name | result = ref(t.continue()).getAMethodCall(name) |
        name = "route" or
        name = routeSetupMethodName()
      )
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2).track(t2, t))
    }

    /**
     * Holds if `sink` may refer to this router.
     */
    predicate flowsTo(Expr sink) { ref(DataFlow::TypeTracker::end()).flowsToExpr(sink) }

    /**
     * Gets a `RouteSetup` that was used for setting up a route on this router.
     */
    private RouteSetup getARouteSetup() { this.flowsTo(result.getReceiver()) }

    /**
     * Gets a sub-router registered on this router.
     *
     * Example: `router2` for `router1.use(router2)` or `router1.use("/route2", router2)`
     */
    RouterDefinition getASubRouter() { result.flowsTo(getARouteSetup().getAnArgument()) }

    /**
     * Gets a route handler registered on this router.
     *
     * Example: `fun` for `router1.use(fun)` or `router.use("/route", fun)`
     */
    HTTP::RouteHandler getARouteHandler() {
      result.(DataFlow::SourceNode).flowsToExpr(getARouteSetup().getAnArgument())
    }

    /**
     * Gets the last middleware in the given router at `node`.
     *
     * For example:
     * ```
     * app = express()
     * app.use(auth)
     * app.use(throttle)
     * ```
     * After line one, the router has no middleware.
     * After line two, the router has `auth` on top of its middleware stack,
     * and after line three, the router has `throttle` on top of its middleware stack.
     *
     * If `node` is not in the same container where `router` was defined, the predicate has no result.
     */
    Express::RouteHandlerExpr getMiddlewareStackAt(ControlFlowNode node) {
      if
        exists(Express::RouteSetup setup | node = setup and setup.getRouter() = this |
          setup.isUseCall()
        )
      then result = node.(Express::RouteSetup).getLastRouteHandlerExpr()
      else result = getMiddlewareStackAt(node.getAPredecessor())
    }

    /**
     * Gets the final middleware registered on this router.
     */
    Express::RouteHandlerExpr getMiddlewareStack() {
      result = getMiddlewareStackAt(getContainer().getExit())
    }
  }

  /** An expression that is passed as `expressBasicAuth({ users: { <user>: <password> }})`. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(DataFlow::CallNode call, DataFlow::ModuleImportNode mod |
        mod.getPath() = "express-basic-auth" and
        call = mod.getAnInvocation() and
        exists(DataFlow::ObjectLiteralNode usersSrc, DataFlow::PropWrite pwn |
          usersSrc.flowsTo(call.getOptionArgument(0, "users")) and
          usersSrc.flowsTo(pwn.getBase())
        |
          this = pwn.getPropertyNameExpr() and kind = "user name"
          or
          this = pwn.getRhs().asExpr() and kind = "password"
        )
      )
    }

    override string getCredentialsKind() { result = kind }
  }

  /** A call to `response.sendFile`, considered as a file system access. */
  private class ResponseSendFileAsFileSystemAccess extends FileSystemReadAccess,
    DataFlow::MethodCallNode {
    ResponseSendFileAsFileSystemAccess() {
      exists(string name | name = "sendFile" or name = "sendfile" |
        calls(any(ResponseExpr res).flow(), name)
      )
    }

    override DataFlow::Node getADataNode() { none() }

    override DataFlow::Node getAPathArgument() { result = getArgument(0) }

    override DataFlow::Node getRootPathArgument() {
      result = this.(DataFlow::CallNode).getOptionArgument(1, "root")
    }

    override predicate isUpwardNavigationRejected(DataFlow::Node argument) {
      argument = getAPathArgument()
    }
  }

  /**
   * A function that flows to a route setup.
   */
  private class TrackedRouteHandlerCandidateWithSetup extends RouteHandler,
    HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    RouteSetup routeSetup;

    TrackedRouteHandlerCandidateWithSetup() { this = routeSetup.getARouteHandler() }

    override Parameter getRouteHandlerParameter(string kind) {
      if routeSetup.isParameterHandler()
      then result = getRouteParameterHandlerParameter(astNode, kind)
      else result = getRouteHandlerParameter(astNode, kind)
    }
  }

  /**
   * A call that looks like a route setup on an Express server.
   *
   * For example, this could be the call `router.use(handler)` or
   * `router.post(handler)` where it is unknown if `router` is an
   * Express router.
   */
  class RouteSetupCandidate extends HTTP::RouteSetupCandidate, DataFlow::MethodCallNode {
    DataFlow::ValueNode routeHandlerArg;

    RouteSetupCandidate() {
      exists(string methodName |
        methodName = "all" or
        methodName = "use" or
        methodName = any(HTTP::RequestMethodName m).toLowerCase()
      |
        getMethodName() = methodName and
        exists(DataFlow::ValueNode arg | arg = getAnArgument() |
          exists(DataFlow::ArrayCreationNode array |
            array.flowsTo(arg) and
            routeHandlerArg = array.getAnElement()
          )
          or
          routeHandlerArg = arg
        )
      )
    }

    override DataFlow::ValueNode getARouteHandlerArg() { result = routeHandlerArg }
  }

  private module WebpackDevServer {
    /**
     * Gets a source for the options given to an instantiation of `webpack-dev-server`.
     */
    private DataFlow::SourceNode devServerOptions(DataFlow::TypeBackTracker t) {
      t.start() and
      result =
        DataFlow::moduleImport("webpack-dev-server")
            .getAnInstantiation()
            .getArgument(1)
            .getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = devServerOptions(t2).backtrack(t2, t))
    }

    /**
     * Gets an instance of the `express` app created by `webpack-dev-server`.
     */
    DataFlow::ParameterNode webpackDevServerApp() {
      result =
        devServerOptions(DataFlow::TypeBackTracker::end())
            .getAPropertyWrite(["after", "before", "setup"])
            .getRhs()
            .getAFunctionValue()
            .getParameter(0)
    }
  }
}
