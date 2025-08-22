/**
 * Provides classes modeling security-relevant aspects of the `twisted` PyPI package.
 * See https://twistedmatrix.com/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * Provides models for the `twisted` PyPI package.
 * See https://twistedmatrix.com/.
 */
private module Twisted {
  // ---------------------------------------------------------------------------
  // request handler modeling
  // ---------------------------------------------------------------------------
  /**
   * A class that is a subclass of `twisted.web.resource.Resource`, thereby
   * being able to handle HTTP requests.
   *
   * See https://twistedmatrix.com/documents/21.2.0/api/twisted.web.resource.Resource.html
   */
  class TwistedResourceSubclass extends Class {
    TwistedResourceSubclass() {
      this.getParent() =
        API::moduleImport("twisted")
            .getMember("web")
            .getMember("resource")
            .getMember("Resource")
            .getASubclass*()
            .asSource()
            .asExpr()
    }

    /** Gets a function that could handle incoming requests, if any. */
    Function getARequestHandler() {
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      exists(getRequestParamIndex(result.getName()))
    }
  }

  /**
   * Gets the index the request parameter is supposed to be at for the method named
   * `methodName` in a `twisted.web.resource.Resource` subclass.
   */
  bindingset[methodName]
  private int getRequestParamIndex(string methodName) {
    methodName.matches("render_%") and result = 1
    or
    methodName in ["render", "listDynamicEntities", "getChildForRequest"] and result = 1
    or
    methodName = ["getDynamicEntity", "getChild", "getChildWithDefault"] and result = 2
  }

  /** A method that handles incoming requests, on a `twisted.web.resource.Resource` subclass. */
  class TwistedResourceRequestHandler extends Http::Server::RequestHandler::Range {
    TwistedResourceRequestHandler() { this = any(TwistedResourceSubclass cls).getARequestHandler() }

    Parameter getRequestParameter() { result = this.getArg(getRequestParamIndex(this.getName())) }

    override Parameter getARoutedParameter() { none() }

    override string getFramework() { result = "twisted" }
  }

  /**
   * A "render" method on a `twisted.web.resource.Resource` subclass, whose return value
   * is written as the body of the HTTP response.
   */
  class TwistedResourceRenderMethod extends TwistedResourceRequestHandler {
    TwistedResourceRenderMethod() {
      this.getName() = "render" or this.getName().matches("render_%")
    }
  }

  // ---------------------------------------------------------------------------
  // request modeling
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `twisted.web.server.Request` class
   *
   * See https://twistedmatrix.com/documents/21.2.0/api/twisted.web.server.Request.html
   */
  module Request {
    /**
     * A source of instances of `twisted.web.server.Request`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use `Request::instance()` predicate to get
     * references to instances of `twisted.web.server.Request`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `twisted.web.server.Request`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `twisted.web.server.Request`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `twisted.web.server.Request`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "twisted.web.server.Request" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "uri", "path", "prepath", "postpath", "content", "args", "received_cookies",
            "requestHeaders", "user", "password", "host"
          ]
      }

      override string getMethodName() {
        result in [
            "getCookie", "getHeader", "getAllHeaders", "getUser", "getPassword", "getHost",
            "getRequestHostname"
          ]
      }

      override string getAsyncMethodName() { none() }
    }
  }

  /**
   * A parameter that will receive a `twisted.web.server.Request` instance,
   * when a twisted request handler is called.
   */
  class TwistedResourceRequestHandlerRequestParam extends RemoteFlowSource::Range,
    Request::InstanceSource, DataFlow::ParameterNode
  {
    TwistedResourceRequestHandlerRequestParam() {
      this.getParameter() = any(TwistedResourceRequestHandler handler).getRequestParameter()
    }

    override string getSourceType() { result = "twisted.web.server.Request" }
  }

  /**
   * A parameter of a request handler method (on a `twisted.web.resource.Resource` subclass)
   * that is also given remote user input. (a bit like RoutedParameter).
   */
  class TwistedResourceRequestHandlerExtraSources extends RemoteFlowSource::Range,
    DataFlow::ParameterNode
  {
    TwistedResourceRequestHandlerExtraSources() {
      exists(TwistedResourceRequestHandler func, int i |
        func.getName() in ["getChild", "getChildWithDefault"] and i = 1
        or
        func.getName() = "getDynamicEntity" and i = 1
      |
        this.getParameter() = func.getArg(i)
      )
    }

    override string getSourceType() { result = "twisted Resource method extra parameter" }
  }

  // ---------------------------------------------------------------------------
  // response modeling
  // ---------------------------------------------------------------------------
  /**
   * Implicit response from returns of render methods.
   */
  private class TwistedResourceRenderMethodReturn extends Http::Server::HttpResponse::Range,
    DataFlow::CfgNode
  {
    TwistedResourceRenderMethodReturn() {
      this.asCfgNode() = any(TwistedResourceRenderMethod meth).getAReturnValueFlowNode()
    }

    override DataFlow::Node getBody() { result = this }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "text/html" }
  }

  /**
   * A call to the `twisted.web.server.Request.write` function.
   *
   * See https://twistedmatrix.com/documents/21.2.0/api/twisted.web.server.Request.html#write
   */
  class TwistedRequestWriteCall extends Http::Server::HttpResponse::Range, DataFlow::MethodCallNode {
    TwistedRequestWriteCall() { this.calls(Request::instance(), "write") }

    override DataFlow::Node getBody() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("data")]
    }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "text/html" }
  }

  /**
   * A call to the `redirect` function on a twisted request.
   *
   * See https://twistedmatrix.com/documents/21.2.0/api/twisted.web.http.Request.html#redirect
   */
  class TwistedRequestRedirectCall extends Http::Server::HttpRedirectResponse::Range,
    DataFlow::MethodCallNode
  {
    TwistedRequestRedirectCall() { this.calls(Request::instance(), "redirect") }

    override DataFlow::Node getBody() { none() }

    override DataFlow::Node getRedirectLocation() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("url")]
    }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "text/html" }
  }

  /**
   * A call to the `addCookie` function on a twisted request.
   *
   * See https://twistedmatrix.com/documents/21.2.0/api/twisted.web.http.Request.html#addCookie
   */
  class TwistedRequestAddCookieCall extends Http::Server::SetCookieCall, DataFlow::MethodCallNode {
    TwistedRequestAddCookieCall() { this.calls(Twisted::Request::instance(), "addCookie") }

    override DataFlow::Node getHeaderArg() { none() }

    override DataFlow::Node getNameArg() { result in [this.getArg(0), this.getArgByName("k")] }

    override DataFlow::Node getValueArg() { result in [this.getArg(1), this.getArgByName("v")] }
  }

  /**
   * A call to `append` on the `cookies` attribute of a twisted request.
   *
   * See https://twistedmatrix.com/documents/21.2.0/api/twisted.web.http.Request.html#cookies
   */
  class TwistedRequestCookiesAppendCall extends Http::Server::CookieWrite::Range,
    DataFlow::MethodCallNode
  {
    TwistedRequestCookiesAppendCall() {
      exists(DataFlow::AttrRead cookiesLookup |
        cookiesLookup.getObject() = Twisted::Request::instance() and
        cookiesLookup.getAttributeName() = "cookies" and
        this.calls(cookiesLookup, "append")
      )
    }

    override DataFlow::Node getHeaderArg() { result = this.getArg(0) }

    override DataFlow::Node getNameArg() { none() }

    override DataFlow::Node getValueArg() { none() }
  }
}
