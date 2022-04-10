/**
 * Provides classes modeling security-relevant aspects of the `aiohttp` PyPI package.
 * See https://docs.aiohttp.org/en/stable/index.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.SelfRefMixin
private import semmle.python.frameworks.Multidict
private import semmle.python.frameworks.Yarl
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the web server part (`aiohttp.web`) of the `aiohttp` PyPI package.
 * See https://docs.aiohttp.org/en/stable/web.html
 */
module AiohttpWebModel {
  /**
   * Provides models for the `aiohttp.web.View` class and subclasses.
   *
   * See https://docs.aiohttp.org/en/stable/web_reference.html#view.
   */
  module View {
    /** Gets a reference to the `aiohttp.web.View` class or any subclass. */
    API::Node subclassRef() {
      result = API::moduleImport("aiohttp").getMember("web").getMember("View").getASubclass*()
    }
  }

  // -- route modeling --
  /** Gets a reference to an `aiohttp.web.Application` instance. */
  API::Node applicationInstance() {
    // Not sure whether you're allowed to add routes _after_ starting the app, for
    // example in the middle of handling a http request... but I'm guessing that for 99%
    // for all code, not modeling that `request.app` is a reference to an application
    // should be good enough for the route-setup part of the modeling :+1:
    result = API::moduleImport("aiohttp").getMember("web").getMember("Application").getReturn()
  }

  /** Gets a reference to an `aiohttp.web.UrlDispatcher` instance. */
  API::Node urlDispathcerInstance() {
    result = API::moduleImport("aiohttp").getMember("web").getMember("UrlDispatcher").getReturn()
    or
    result = applicationInstance().getMember("router")
  }

  /**
   * A route setup in `aiohttp.web`. Since all route-setups can technically use either
   * coroutines or view-classes as the handler argument (although that's not how you're
   * **supposed** to do things), we also need to handle this.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `AiohttpRouteSetup::Range` instead.
   */
  class AiohttpRouteSetup extends HTTP::Server::RouteSetup::Range {
    AiohttpRouteSetup::Range range;

    AiohttpRouteSetup() { this = range }

    override Parameter getARoutedParameter() { none() }

    override string getFramework() { result = "aiohttp.web" }

    /** Gets the argument specifying the handler (either a coroutine or a view-class). */
    DataFlow::Node getHandlerArg() { result = range.getHandlerArg() }

    override DataFlow::Node getUrlPatternArg() { result = range.getUrlPatternArg() }

    /** Gets the view-class that is referenced in the view-class handler argument, if any. */
    Class getViewClass() { result = range.getViewClass() }

    override Function getARequestHandler() { result = range.getARequestHandler() }
  }

  /** Provides a class for modeling new aiohttp.web route setups. */
  private module AiohttpRouteSetup {
    /**
     * A route setup in `aiohttp.web`. Since all route-setups can technically use either
     * coroutines or view-classes as the handler argument (although that's not how you're
     * **supposed** to do things), we also need to handle this.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `AiohttpRouteSetup` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the argument used to set the URL pattern. */
      abstract DataFlow::Node getUrlPatternArg();

      /** Gets the argument specifying the handler (either a coroutine or a view-class). */
      abstract DataFlow::Node getHandlerArg();

      /** Gets the view-class that is referenced in the view-class handler argument, if any. */
      Class getViewClass() { result = getBackTrackedViewClass(this.getHandlerArg()) }

      /**
       * Gets a function that will handle incoming requests for this route, if any.
       *
       * NOTE: This will be modified in the near future to have a `RequestHandler` result, instead of a `Function`.
       */
      Function getARequestHandler() {
        this.getHandlerArg() = poorMansFunctionTracker(result)
        or
        result = this.getViewClass().(AiohttpViewClass).getARequestHandler()
      }
    }

    /**
     * Gets a reference to a class, that has been backtracked from the view-class handler
     * argument `origin` (to a route-setup for view-classes).
     */
    private DataFlow::TypeTrackingNode viewClassBackTracker(
      DataFlow::TypeBackTracker t, DataFlow::Node origin
    ) {
      t.start() and
      origin = any(Range rs).getHandlerArg() and
      result = origin.getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 |
        result = viewClassBackTracker(t2, origin).backtrack(t2, t)
      )
    }

    /**
     * Gets a reference to a class, that has been backtracked from the view-class handler
     * argument `origin` (to a route-setup for view-classes).
     */
    DataFlow::LocalSourceNode viewClassBackTracker(DataFlow::Node origin) {
      result = viewClassBackTracker(DataFlow::TypeBackTracker::end(), origin)
    }

    Class getBackTrackedViewClass(DataFlow::Node origin) {
      result.getParent() = viewClassBackTracker(origin).asExpr()
    }
  }

  /** An aiohttp route setup that uses coroutines (async function) as request handlers. */
  class AiohttpCoroutineRouteSetup extends AiohttpRouteSetup {
    AiohttpCoroutineRouteSetup() { this.getHandlerArg() = poorMansFunctionTracker(_) }
  }

  /** An aiohttp route setup that uses view-classes as request handlers. */
  class AiohttpViewRouteSetup extends AiohttpRouteSetup {
    AiohttpViewRouteSetup() { exists(this.getViewClass()) }
  }

  /**
   * A route-setup from
   * - `add_route`, `add_view`, `add_get`, `add_post`, , etc. on an `aiohttp.web.UrlDispatcher`.
   * - `route`, `view`, `get`, `post`, etc. functions from `aiohttp.web`.
   */
  class AiohttpAddRouteCall extends AiohttpRouteSetup::Range, DataFlow::CallCfgNode {
    /** At what index route arguments starts, so we can handle "route" version together with get/post/... */
    int routeArgsStart;

    AiohttpAddRouteCall() {
      exists(string funcName |
        funcName = HTTP::httpVerbLower() and
        routeArgsStart = 0
        or
        funcName = "view" and
        routeArgsStart = 0
        or
        funcName = "route" and
        routeArgsStart = 1
      |
        this = urlDispathcerInstance().getMember("add_" + funcName).getACall()
        or
        this = API::moduleImport("aiohttp").getMember("web").getMember(funcName).getACall()
      )
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(routeArgsStart + 0), this.getArgByName("path")]
    }

    override DataFlow::Node getHandlerArg() {
      result in [this.getArg(routeArgsStart + 1), this.getArgByName("handler")]
    }
  }

  /** A route-setup using a decorator, such as `route`, `view`, `get`, `post`, etc. on an `aiohttp.web.RouteTableDef`. */
  class AiohttpDecoratorRouteSetup extends AiohttpRouteSetup::Range, DataFlow::CallCfgNode {
    /** At what index route arguments starts, so we can handle "route" version together with get/post/... */
    int routeArgsStart;

    AiohttpDecoratorRouteSetup() {
      exists(string decoratorName |
        decoratorName = HTTP::httpVerbLower() and
        routeArgsStart = 0
        or
        decoratorName = "view" and
        routeArgsStart = 0
        or
        decoratorName = "route" and
        routeArgsStart = 1
      |
        this =
          API::moduleImport("aiohttp")
              .getMember("web")
              .getMember("RouteTableDef")
              .getReturn()
              .getMember(decoratorName)
              .getACall()
      )
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(routeArgsStart + 0), this.getArgByName("path")]
    }

    override DataFlow::Node getHandlerArg() { none() }

    override Class getViewClass() { result.getADecorator() = this.asExpr() }

    override Function getARequestHandler() {
      // we're decorating a class
      exists(this.getViewClass()) and
      result = super.getARequestHandler()
      or
      // we're decorating a function
      not exists(this.getViewClass()) and
      result.getADecorator() = this.asExpr()
    }
  }

  /** A class that we consider an aiohttp.web View class. */
  abstract class AiohttpViewClass extends Class, SelfRefMixin {
    /** Gets a function that could handle incoming requests, if any. */
    Function getARequestHandler() {
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      result.getName() = HTTP::httpVerbLower()
    }
  }

  /** A class that has a super-type which is an aiohttp.web View class. */
  class AiohttpViewClassFromSuperClass extends AiohttpViewClass {
    AiohttpViewClassFromSuperClass() {
      this.getParent() = View::subclassRef().getAnImmediateUse().asExpr()
    }
  }

  /** A class that is used in a route-setup, therefore being considered an aiohttp.web View class. */
  class AiohttpViewClassFromRouteSetup extends AiohttpViewClass {
    AiohttpViewClassFromRouteSetup() { this = any(AiohttpRouteSetup rs).getViewClass() }
  }

  /** A request handler defined in an `aiohttp.web` view class, that has no known route. */
  private class AiohttpViewClassRequestHandlerWithoutKnownRoute extends HTTP::Server::RequestHandler::Range {
    AiohttpViewClassRequestHandlerWithoutKnownRoute() {
      exists(AiohttpViewClass vc | vc.getARequestHandler() = this) and
      not exists(AiohttpRouteSetup setup | setup.getARequestHandler() = this)
    }

    override Parameter getARoutedParameter() { none() }

    override string getFramework() { result = "aiohttp.web" }
  }

  // ---------------------------------------------------------------------------
  // aiohttp.web.Request taint modeling
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `aiohttp.web.Request` class
   *
   * See https://docs.aiohttp.org/en/stable/web_reference.html#request-and-base-request
   */
  module Request {
    /**
     * A source of instances of `aiohttp.web.Request`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use `Request::instance()` predicate to get
     * references to instances of `aiohttp.web.Request`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `aiohttp.web.Request`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `aiohttp.web.Request`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `aiohttp.web.Request`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "aiohttp.web.Request" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "url", "rel_url", "forwarded", "host", "remote", "path", "path_qs", "raw_path", "query",
            "headers", "transport", "cookies", "content", "_payload", "content_type", "charset",
            "http_range", "if_modified_since", "if_unmodified_since", "if_range", "match_info"
          ]
      }

      override string getMethodName() { result in ["clone", "get_extra_info"] }

      override string getAsyncMethodName() {
        result in ["read", "text", "json", "multipart", "post"]
      }
    }

    /** An attribute read on an `aiohttp.web.Request` that is a `MultiDictProxy` instance. */
    class AiohttpRequestMultiDictProxyInstances extends Multidict::MultiDictProxy::InstanceSource {
      AiohttpRequestMultiDictProxyInstances() {
        this.(DataFlow::AttrRead).getObject() = Request::instance() and
        this.(DataFlow::AttrRead).getAttributeName() in ["query", "headers"]
        or
        // Handle the common case of `x = await request.post()`
        // but don't try to handle anything else, since we don't have an easy way to do this yet.
        // TODO: more complete handling of `await request.post()`
        exists(Await await, DataFlow::CallCfgNode call, DataFlow::AttrRead read |
          this.asExpr() = await
        |
          read.getObject() = Request::instance() and
          read.getAttributeName() = "post" and
          call.getFunction() = read and
          await.getValue() = call.asExpr()
        )
      }
    }

    /** An attribute read on an `aiohttp.web.Request` that is a `yarl.URL` instance. */
    class AiohttpRequestYarlUrlInstances extends Yarl::Url::InstanceSource {
      AiohttpRequestYarlUrlInstances() {
        this.(DataFlow::AttrRead).getObject() = Request::instance() and
        this.(DataFlow::AttrRead).getAttributeName() in ["url", "rel_url"]
      }
    }

    /** An attribute read on an `aiohttp.web.Request` that is a `aiohttp.StreamReader` instance. */
    class AiohttpRequestStreamReaderInstances extends StreamReader::InstanceSource {
      AiohttpRequestStreamReaderInstances() {
        this.(DataFlow::AttrRead).getObject() = Request::instance() and
        this.(DataFlow::AttrRead).getAttributeName() in ["content", "_payload"]
      }
    }
  }

  /**
   * Provides models for the `aiohttp.web.Response` class
   *
   * See https://docs.aiohttp.org/en/stable/web_reference.html#response-classes
   */
  module Response {
    /**
     * A source of instances of `aiohttp.web.Response`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use `Response::instance()` predicate to get
     * references to instances of `aiohttp.web.Response`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `aiohttp.web.Response`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `aiohttp.web.Response`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /**
   * Provides models for the `aiohttp.StreamReader` class
   *
   * See https://docs.aiohttp.org/en/stable/streams.html#aiohttp.StreamReader
   */
  module StreamReader {
    /**
     * A source of instances of `aiohttp.StreamReader`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use `StreamReader::instance()` predicate to get
     * references to instances of `aiohttp.StreamReader`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `aiohttp.StreamReader`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `aiohttp.StreamReader`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `aiohttp.StreamReader`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "aiohttp.StreamReader" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() { result = "read_nowait" }

      override string getAsyncMethodName() {
        result in [
            "read", "readany", "readexactly", "readline", "readchunk", "iter_chunked", "iter_any",
            "iter_chunks"
          ]
      }
    }
  }

  /**
   * A parameter that will receive an `aiohttp.web.Request` instance when a request
   * handler is invoked.
   */
  class AiohttpRequestHandlerRequestParam extends Request::InstanceSource, RemoteFlowSource::Range,
    DataFlow::ParameterNode {
    AiohttpRequestHandlerRequestParam() {
      exists(Function requestHandler |
        requestHandler = any(AiohttpCoroutineRouteSetup setup).getARequestHandler() and
        // We select the _last_ parameter for the request since that is what they do in
        // `aiohttp-jinja2`.
        // https://github.com/aio-libs/aiohttp-jinja2/blob/7fb4daf2c3003921d34031d38c2311ee0e02c18b/aiohttp_jinja2/__init__.py#L235
        //
        // I assume that is just to handle cases such as the one below
        // ```py
        // class MyCustomHandlerClass:
        //     async def foo_handler(self, request):
        //            ...
        //
        // my_custom_handler = MyCustomHandlerClass()
        // app.router.add_get("/MyCustomHandlerClass/foo", my_custom_handler.foo_handler)
        // ```
        this.getParameter() =
          max(Parameter param, int i | param = requestHandler.getArg(i) | param order by i)
      )
    }

    override string getSourceType() { result = "aiohttp.web.Request" }
  }

  /**
   * A read of the `request` attribute on an instance of an aiohttp.web View class,
   * which is the request being processed currently.
   */
  class AiohttpViewClassRequestAttributeRead extends Request::InstanceSource,
    RemoteFlowSource::Range, DataFlow::Node {
    AiohttpViewClassRequestAttributeRead() {
      this.(DataFlow::AttrRead).getObject() = any(AiohttpViewClass vc).getASelfRef() and
      this.(DataFlow::AttrRead).getAttributeName() = "request"
    }

    override string getSourceType() {
      result = "aiohttp.web.Request from self.request in View class"
    }
  }

  // ---------------------------------------------------------------------------
  // aiohttp.web Response modeling
  // ---------------------------------------------------------------------------
  /**
   * An instantiation of `aiohttp.web.Response`.
   *
   * Note that `aiohttp.web.HTTPException` (and it's subclasses) is a subclass of `aiohttp.web.Response`.
   *
   * See
   * - https://docs.aiohttp.org/en/stable/web_reference.html#aiohttp.web.Response
   * - https://docs.aiohttp.org/en/stable/web_quickstart.html#aiohttp-web-exceptions
   */
  class AiohttpWebResponseInstantiation extends HTTP::Server::HttpResponse::Range,
    Response::InstanceSource, DataFlow::CallCfgNode {
    API::Node apiNode;

    AiohttpWebResponseInstantiation() {
      this = apiNode.getACall() and
      (
        apiNode = API::moduleImport("aiohttp").getMember("web").getMember("Response")
        or
        exists(string httpExceptionClassName |
          httpExceptionClassName in [
              "HTTPException", "HTTPSuccessful", "HTTPOk", "HTTPCreated", "HTTPAccepted",
              "HTTPNonAuthoritativeInformation", "HTTPNoContent", "HTTPResetContent",
              "HTTPPartialContent", "HTTPRedirection", "HTTPMultipleChoices",
              "HTTPMovedPermanently", "HTTPFound", "HTTPSeeOther", "HTTPNotModified",
              "HTTPUseProxy", "HTTPTemporaryRedirect", "HTTPPermanentRedirect", "HTTPError",
              "HTTPClientError", "HTTPBadRequest", "HTTPUnauthorized", "HTTPPaymentRequired",
              "HTTPForbidden", "HTTPNotFound", "HTTPMethodNotAllowed", "HTTPNotAcceptable",
              "HTTPProxyAuthenticationRequired", "HTTPRequestTimeout", "HTTPConflict", "HTTPGone",
              "HTTPLengthRequired", "HTTPPreconditionFailed", "HTTPRequestEntityTooLarge",
              "HTTPRequestURITooLong", "HTTPUnsupportedMediaType", "HTTPRequestRangeNotSatisfiable",
              "HTTPExpectationFailed", "HTTPMisdirectedRequest", "HTTPUnprocessableEntity",
              "HTTPFailedDependency", "HTTPUpgradeRequired", "HTTPPreconditionRequired",
              "HTTPTooManyRequests", "HTTPRequestHeaderFieldsTooLarge",
              "HTTPUnavailableForLegalReasons", "HTTPServerError", "HTTPInternalServerError",
              "HTTPNotImplemented", "HTTPBadGateway", "HTTPServiceUnavailable",
              "HTTPGatewayTimeout", "HTTPVersionNotSupported", "HTTPVariantAlsoNegotiates",
              "HTTPInsufficientStorage", "HTTPNotExtended", "HTTPNetworkAuthenticationRequired"
            ] and
          apiNode = API::moduleImport("aiohttp").getMember("web").getMember(httpExceptionClassName)
        )
      )
    }

    /**
     * INTERNAL: Do not use.
     *
     * Get the internal `API::Node` that this is call of.
     */
    API::Node getApiNode() { result = apiNode }

    override DataFlow::Node getBody() {
      result in [this.getArgByName("text"), this.getArgByName("body")]
    }

    override DataFlow::Node getMimetypeOrContentTypeArg() {
      result = this.getArgByName("content_type")
    }

    override string getMimetypeDefault() {
      exists(this.getArgByName("text")) and
      result = "text/plain"
      or
      not exists(this.getArgByName("text")) and
      result = "application/octet-stream"
    }
  }

  /** Gets an HTTP response instance. */
  private API::Node aiohttpResponseInstance() {
    result = any(AiohttpWebResponseInstantiation call).getApiNode().getReturn()
  }

  /**
   * An instantiation of aiohttp.web HTTP redirect exception.
   *
   * See the part about redirects at https://docs.aiohttp.org/en/stable/web_quickstart.html#aiohttp-web-exceptions
   */
  class AiohttpRedirectExceptionInstantiation extends AiohttpWebResponseInstantiation,
    HTTP::Server::HttpRedirectResponse::Range {
    AiohttpRedirectExceptionInstantiation() {
      exists(string httpRedirectExceptionClassName |
        httpRedirectExceptionClassName in [
            "HTTPMultipleChoices", "HTTPMovedPermanently", "HTTPFound", "HTTPSeeOther",
            "HTTPNotModified", "HTTPUseProxy", "HTTPTemporaryRedirect", "HTTPPermanentRedirect"
          ] and
        this =
          API::moduleImport("aiohttp")
              .getMember("web")
              .getMember(httpRedirectExceptionClassName)
              .getACall()
      )
    }

    override DataFlow::Node getRedirectLocation() {
      result in [this.getArg(0), this.getArgByName("location")]
    }
  }

  /**
   * A call to `set_cookie` on a HTTP Response.
   */
  class AiohttpResponseSetCookieCall extends HTTP::Server::CookieWrite::Range, DataFlow::CallCfgNode {
    AiohttpResponseSetCookieCall() {
      this = aiohttpResponseInstance().getMember("set_cookie").getACall()
    }

    override DataFlow::Node getHeaderArg() { none() }

    override DataFlow::Node getNameArg() { result in [this.getArg(0), this.getArgByName("name")] }

    override DataFlow::Node getValueArg() { result in [this.getArg(1), this.getArgByName("value")] }
  }

  /**
   * A call to `del_cookie` on a HTTP Response.
   */
  class AiohttpResponseDelCookieCall extends HTTP::Server::CookieWrite::Range, DataFlow::CallCfgNode {
    AiohttpResponseDelCookieCall() {
      this = aiohttpResponseInstance().getMember("del_cookie").getACall()
    }

    override DataFlow::Node getHeaderArg() { none() }

    override DataFlow::Node getNameArg() { result in [this.getArg(0), this.getArgByName("name")] }

    override DataFlow::Node getValueArg() { none() }
  }

  /**
   * A dict-like write to an item of the `cookies` attribute on a HTTP response, such as
   * `response.cookies[name] = value`.
   */
  class AiohttpResponseCookieSubscriptWrite extends HTTP::Server::CookieWrite::Range {
    DataFlow::Node index;
    DataFlow::Node value;

    AiohttpResponseCookieSubscriptWrite() {
      exists(SubscriptNode subscript |
        // To give `this` a value, we need to choose between either LHS or RHS,
        // and just go with the LHS
        this.asCfgNode() = subscript
      |
        subscript.getObject() = aiohttpResponseInstance().getMember("cookies").getAUse().asCfgNode() and
        value.asCfgNode() = subscript.(DefinitionNode).getValue() and
        index.asCfgNode() = subscript.getIndex()
      )
    }

    override DataFlow::Node getHeaderArg() { none() }

    override DataFlow::Node getNameArg() { result = index }

    override DataFlow::Node getValueArg() { result = value }
  }
}

/**
 * Provides models for the web server part (`aiohttp.client`) of the `aiohttp` PyPI package.
 * See https://docs.aiohttp.org/en/stable/client.html
 */
private module AiohttpClientModel {
  /**
   * Provides models for the `aiohttp.ClientSession` class
   *
   * See https://docs.aiohttp.org/en/stable/client_reference.html#aiohttp.ClientSession.
   */
  module ClientSession {
    /** Gets a reference to the `aiohttp.ClientSession` class. */
    private API::Node classRef() {
      result = API::moduleImport("aiohttp").getMember("ClientSession")
    }

    /** Gets a reference to an instance of `aiohttp.ClientSession`. */
    private API::Node instance() { result = classRef().getReturn() }

    /** A method call on a ClientSession that sends off a request */
    private class OutgoingRequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      string methodName;

      OutgoingRequestCall() {
        methodName in [HTTP::httpVerbLower(), "request"] and
        this = instance().getMember(methodName).getACall()
      }

      override DataFlow::Node getAUrlPart() {
        result = this.getArgByName("url")
        or
        not methodName = "request" and
        result = this.getArg(0)
        or
        methodName = "request" and
        result = this.getArg(1)
      }

      override string getFramework() { result = "aiohttp.ClientSession" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Look into disabling certificate validation
        none()
      }
    }
  }
}
