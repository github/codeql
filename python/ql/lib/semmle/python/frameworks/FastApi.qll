/**
 * Provides classes modeling security-relevant aspects of the `fastapi` PyPI package.
 * See https://fastapi.tiangolo.com/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.Pydantic
private import semmle.python.frameworks.Starlette
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `fastapi` PyPI package.
 * See https://fastapi.tiangolo.com/.
 */
module FastApi {
  /**
   * Provides models for FastAPI applications (an instance of `fastapi.FastAPI`).
   */
  module App {
    API::Node cls() { result = API::moduleImport("fastapi").getMember("FastAPI") }

    /** Gets a reference to a FastAPI application (an instance of `fastapi.FastAPI`). */
    API::Node instance() { result = cls().getReturn() }
  }

  /**
   * A call to `app.add_middleware` adding a generic middleware.
   */
  private class AddMiddlewareCall extends DataFlow::CallCfgNode {
    AddMiddlewareCall() { this = App::instance().getMember("add_middleware").getACall() }

    /**
     * Gets the string corresponding to the middleware
     */
    string getMiddlewareName() { result = this.getArg(0).asExpr().(Name).getId() }
  }

  /**
   * A call to `app.add_middleware` adding CORSMiddleware.
   */
  class AddCorsMiddlewareCall extends Http::Server::CorsMiddleware::Range, AddMiddlewareCall {
    /**
     * Gets the string corresponding to the middleware
     */
    override string getMiddlewareName() { result = this.getArg(0).asExpr().(Name).getId() }

    /**
     * Gets the dataflow node corresponding to the allowed CORS origins
     */
    override DataFlow::Node getOrigins() { result = this.getArgByName("allow_origins") }

    /**
     * Gets the boolean value corresponding to if CORS credentials is enabled
     * (`true`) or disabled (`false`) by this node.
     */
    override DataFlow::Node getCredentialsAllowed() {
      result = this.getArgByName("allow_credentials")
    }

    /**
     * Gets the dataflow node corresponding to the allowed CORS methods
     */
    DataFlow::Node getMethods() { result = this.getArgByName("allow_methods") }

    /**
     * Gets the dataflow node corresponding to the allowed CORS headers
     */
    DataFlow::Node getHeaders() { result = this.getArgByName("allow_headers") }
  }

  /**
   * Provides models for the `fastapi.APIRouter` class
   *
   * See https://fastapi.tiangolo.com/tutorial/bigger-applications/.
   */
  module ApiRouter {
    API::Node cls() {
      result = API::moduleImport("fastapi").getMember("APIRouter").getASubclass*()
      or
      result = ModelOutput::getATypeNode("fastapi.APIRouter~Subclass").getASubclass*()
    }

    /** Gets a reference to an instance of `fastapi.ApiRouter`. */
    API::Node instance() { result = cls().getReturn() }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
  /**
   * A call to a method like `get` or `post` on a FastAPI application.
   *
   * See https://fastapi.tiangolo.com/tutorial/first-steps/#define-a-path-operation-decorator
   */
  private class FastApiRouteSetup extends Http::Server::RouteSetup::Range, DataFlow::CallCfgNode {
    FastApiRouteSetup() {
      exists(string routeAddingMethod |
        routeAddingMethod = Http::httpVerbLower()
        or
        routeAddingMethod in ["api_route", "websocket"]
      |
        this = App::instance().getMember(routeAddingMethod).getACall()
        or
        this = ApiRouter::instance().getMember(routeAddingMethod).getACall()
      )
    }

    override Parameter getARoutedParameter() {
      // this will need to be refined a bit, since you can add special parameters to
      // your request handler functions that are used to pass in the response. There
      // might be other special cases as well, but as a start this is not too far off
      // the mark.
      result = this.getARequestHandler().getArgByName(_) and
      // type-annotated with `Response`
      not any(Response::RequestHandlerParam src).asExpr() = result
      or
      // **kwargs
      result = this.getARequestHandler().getKwarg()
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override Function getARequestHandler() { result.getADecorator().getAFlowNode() = node }

    override string getFramework() { result = "FastAPI" }

    /** Gets the argument specifying the response class to use, if any. */
    DataFlow::Node getResponseClassArg() { result = this.getArgByName("response_class") }
  }

  /**
   * A parameter to a request handler that has a type-annotation with a class that is a
   * Pydantic model.
   */
  private class PydanticModelRequestHandlerParam extends Pydantic::BaseModel::InstanceSource,
    DataFlow::ParameterNode
  {
    PydanticModelRequestHandlerParam() {
      this.getParameter().getAnnotation() =
        Pydantic::BaseModel::subclassRef().getAValueReachableFromSource().asExpr() and
      any(FastApiRouteSetup rs).getARequestHandler().getArgByName(_) = this.getParameter()
    }
  }

  // ---------------------------------------------------------------------------
  // Response modeling
  // ---------------------------------------------------------------------------
  /**
   * A parameter to a request handler that has a WebSocket type-annotation.
   */
  private class WebSocketRequestHandlerParam extends Starlette::WebSocket::InstanceSource,
    DataFlow::ParameterNode
  {
    WebSocketRequestHandlerParam() {
      this.getParameter().getAnnotation() =
        Starlette::WebSocket::classRef().getAValueReachableFromSource().asExpr() and
      any(FastApiRouteSetup rs).getARequestHandler().getArgByName(_) = this.getParameter()
    }
  }

  /**
   * Provides models for the `fastapi.Response` class and subclasses.
   *
   * See https://fastapi.tiangolo.com/advanced/custom-response/#response.
   */
  module Response {
    /**
     * Gets the `API::Node` for the manually modeled response classes called `name`.
     */
    private API::Node getModeledResponseClass(string name) {
      name = "Response" and
      result = API::moduleImport("fastapi").getMember(name)
      or
      // see https://github.com/tiangolo/fastapi/blob/master/fastapi/responses.py
      name in [
          "Response", "HTMLResponse", "PlainTextResponse", "JSONResponse", "UJSONResponse",
          "ORJSONResponse", "RedirectResponse", "StreamingResponse", "FileResponse"
        ] and
      result = API::moduleImport("fastapi").getMember("responses").getMember(name)
    }

    /**
     * Gets the default MIME type for a FastAPI response class (defined with the
     * `media_type` class-attribute).
     *
     * Also models user-defined classes and tries to take inheritance into account.
     *
     * TODO: build easy way to solve problems like this, like we used to have the
     * `ClassValue.lookup` predicate.
     */
    private string getDefaultMimeType(API::Node responseClass) {
      exists(string name | responseClass = getModeledResponseClass(name) |
        // no defaults for these.
        name in ["Response", "RedirectResponse", "StreamingResponse"] and
        none()
        or
        // For `FileResponse` the code will guess what mimetype
        // to use, or fall back to "text/plain", but claiming that all responses will
        // have "text/plain" per default is also highly inaccurate, so just going to not
        // do anything about this.
        name = "FileResponse" and
        none()
        or
        name = "HTMLResponse" and
        result = "text/html"
        or
        name = "PlainTextResponse" and
        result = "text/plain"
        or
        name in ["JSONResponse", "UJSONResponse", "ORJSONResponse"] and
        result = "application/json"
      )
      or
      // user-defined subclasses
      exists(Class cls, API::Node base |
        base = getModeledResponseClass(_).getASubclass*() and
        cls.getABase() = base.getAValueReachableFromSource().asExpr() and
        responseClass.asSource().asExpr() = cls.getParent()
      |
        exists(Assign assign | assign = cls.getAStmt() |
          assign.getATarget().(Name).getId() = "media_type" and
          result = assign.getValue().(StringLiteral).getText()
        )
        or
        // TODO: this should use a proper MRO calculation instead
        not exists(Assign assign | assign = cls.getAStmt() |
          assign.getATarget().(Name).getId() = "media_type"
        ) and
        result = getDefaultMimeType(base)
      )
    }

    /**
     * A source of instances of `fastapi.Response` and its' subclasses, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Response::instance()` to get references to instances of `fastapi.Response`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of a response class. */
    private class ResponseInstantiation extends InstanceSource, Http::Server::HttpResponse::Range,
      DataFlow::CallCfgNode
    {
      API::Node baseApiNode;
      API::Node responseClass;

      ResponseInstantiation() {
        baseApiNode = getModeledResponseClass(_) and
        responseClass = baseApiNode.getASubclass*() and
        this = responseClass.getACall()
      }

      override DataFlow::Node getBody() {
        not baseApiNode = getModeledResponseClass(["RedirectResponse", "FileResponse"]) and
        result in [this.getArg(0), this.getArgByName("content")]
      }

      override DataFlow::Node getMimetypeOrContentTypeArg() {
        not baseApiNode = getModeledResponseClass("RedirectResponse") and
        result in [this.getArg(3), this.getArgByName("media_type")]
      }

      override string getMimetypeDefault() { result = getDefaultMimeType(responseClass) }
    }

    /**
     * A direct instantiation of a redirect response.
     */
    private class RedirectResponseInstantiation extends ResponseInstantiation,
      Http::Server::HttpRedirectResponse::Range
    {
      RedirectResponseInstantiation() { baseApiNode = getModeledResponseClass("RedirectResponse") }

      override DataFlow::Node getRedirectLocation() {
        result in [this.getArg(0), this.getArgByName("url")]
      }
    }

    /**
     * A direct instantiation of a FileResponse.
     */
    private class FileResponseInstantiation extends ResponseInstantiation, FileSystemAccess::Range {
      FileResponseInstantiation() { baseApiNode = getModeledResponseClass("FileResponse") }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * An implicit response from a return of FastAPI request handler.
     */
    private class FastApiRequestHandlerReturn extends Http::Server::HttpResponse::Range,
      DataFlow::CfgNode
    {
      FastApiRouteSetup routeSetup;

      FastApiRequestHandlerReturn() {
        node = routeSetup.getARequestHandler().getAReturnValueFlowNode()
      }

      override DataFlow::Node getBody() { result = this }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() {
        exists(API::Node responseClass |
          responseClass.getAValueReachableFromSource() = routeSetup.getResponseClassArg() and
          result = getDefaultMimeType(responseClass)
        )
        or
        not exists(routeSetup.getResponseClassArg()) and
        result = "application/json"
      }
    }

    /**
     * An implicit response from a return of FastAPI request handler, that has
     * `response_class` set to a `FileResponse`.
     */
    private class FastApiRequestHandlerFileResponseReturn extends FastApiRequestHandlerReturn,
      FileSystemAccess::Range
    {
      FastApiRequestHandlerFileResponseReturn() {
        exists(API::Node responseClass |
          responseClass.getAValueReachableFromSource() = routeSetup.getResponseClassArg() and
          responseClass = getModeledResponseClass("FileResponse").getASubclass*()
        )
      }

      override DataFlow::Node getBody() { none() }

      override DataFlow::Node getAPathArgument() { result = this }
    }

    /**
     * An implicit response from a return of FastAPI request handler, that has
     * `response_class` set to a `RedirectResponse`.
     */
    private class FastApiRequestHandlerRedirectReturn extends FastApiRequestHandlerReturn,
      Http::Server::HttpRedirectResponse::Range
    {
      FastApiRequestHandlerRedirectReturn() {
        exists(API::Node responseClass |
          responseClass.getAValueReachableFromSource() = routeSetup.getResponseClassArg() and
          responseClass = getModeledResponseClass("RedirectResponse").getASubclass*()
        )
      }

      override DataFlow::Node getBody() { none() }

      override DataFlow::Node getRedirectLocation() { result = this }
    }

    /**
     * INTERNAL: Do not use.
     *
     * A parameter to a FastAPI request-handler that has a `fastapi.Response`
     * type-annotation.
     */
    class RequestHandlerParam extends InstanceSource, DataFlow::ParameterNode {
      RequestHandlerParam() {
        this.getParameter().getAnnotation() =
          getModeledResponseClass(_).getASubclass*().getAValueReachableFromSource().asExpr() and
        any(FastApiRouteSetup rs).getARequestHandler().getArgByName(_) = this.getParameter()
      }
    }

    /** Gets a reference to an instance of `fastapi.Response`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `fastapi.Response`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * A call to `set_cookie` on a FastAPI Response.
     */
    private class SetCookieCall extends Http::Server::SetCookieCall, DataFlow::MethodCallNode {
      SetCookieCall() { this.calls(instance(), "set_cookie") }

      override DataFlow::Node getHeaderArg() { none() }

      override DataFlow::Node getNameArg() { result in [this.getArg(0), this.getArgByName("key")] }

      override DataFlow::Node getValueArg() {
        result in [this.getArg(1), this.getArgByName("value")]
      }
    }

    /**
     * A call to `append` on a `headers` of a FastAPI Response.
     */
    private class HeadersAppend extends Http::Server::ResponseHeaderWrite::Range,
      DataFlow::MethodCallNode
    {
      HeadersAppend() {
        exists(DataFlow::AttrRead headers |
          headers.accesses(instance(), "headers") and
          this.calls(headers, "append")
        )
      }

      override DataFlow::Node getNameArg() { result = [this.getArg(0), this.getArgByName("key")] }

      override DataFlow::Node getValueArg() {
        result in [this.getArg(1), this.getArgByName("value")]
      }

      override predicate nameAllowsNewline() { none() }

      override predicate valueAllowsNewline() { none() }
    }

    /**
     * A dict-like write to an item of the `headers` attribute on a HTTP response, such as
     * `response.headers[name] = value`.
     */
    class HeaderSubscriptWrite extends Http::Server::ResponseHeaderWrite::Range {
      DataFlow::Node index;
      DataFlow::Node value;

      HeaderSubscriptWrite() {
        exists(SubscriptNode subscript, DataFlow::AttrRead headerLookup |
          // To give `this` a value, we need to choose between either LHS or RHS,
          // and just go with the LHS
          this.asCfgNode() = subscript
        |
          headerLookup.accesses(instance(), "headers") and
          exists(DataFlow::Node subscriptObj | subscriptObj.asCfgNode() = subscript.getObject() |
            headerLookup.flowsTo(subscriptObj)
          ) and
          value.asCfgNode() = subscript.(DefinitionNode).getValue() and
          index.asCfgNode() = subscript.getIndex()
        )
      }

      override DataFlow::Node getNameArg() { result = index }

      override DataFlow::Node getValueArg() { result = value }

      override predicate nameAllowsNewline() { none() }

      override predicate valueAllowsNewline() { none() }
    }
  }
}
