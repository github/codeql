/**
 * Provides classes modeling security-relevant aspects of the `aiohttp` PyPI package.
 * See https://docs.aiohttp.org/en/stable/index.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.PoorMansFunctionResolution

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the web server part (`aiohttp.web`) of the `aiohttp` PyPI package.
 * See https://docs.aiohttp.org/en/stable/web.html
 */
module AiohttpWebModel {
  /** Gets a reference to a `aiohttp.web.Application` instance. */
  API::Node applicationInstance() {
    // Not sure whether you're allowed to add routes _after_ starting the app, for
    // example in the middle of handling a http request... but I'm guessing that for 99%
    // for all code, not modeling that `request.app` is a reference to an application
    // should be good enough for the route-setup part of the modeling :+1:
    result = API::moduleImport("aiohttp").getMember("web").getMember("Application").getReturn()
  }

  /** Gets a reference to a `aiohttp.web.UrlDispatcher` instance. */
  API::Node urlDispathcerInstance() {
    result = API::moduleImport("aiohttp").getMember("web").getMember("UrlDispatcher").getReturn()
    or
    result = applicationInstance().getMember("router")
  }

  // -- route modeling --

  /** A route setup in `aiohttp.web` */
  abstract class AiohttpRouteSetup extends HTTP::Server::RouteSetup::Range {
    override Parameter getARoutedParameter() { none() }

    override string getFramework() { result = "aiohttp.web" }
  }

  /** An aiohttp route setup that uses coroutines (async function) as request handler. */
  abstract class AiohttpCoroutineRouteSetup extends AiohttpRouteSetup {
    /** Gets the argument specifying the request handler (which is a coroutine/async function) */
    abstract DataFlow::Node getRequestHandlerArg();

    override Function getARequestHandler() {
      this.getRequestHandlerArg() = poorMansFunctionTracker(result)
    }
  }

  /**
   * A route-setup from `add_route` or any of `add_get`, `add_post`, etc. on an
   *    `aiohttp.web.UrlDispatcher`.
   */
  class AiohttpUrlDispatcherAddRouteCall extends AiohttpCoroutineRouteSetup, DataFlow::CallCfgNode {
    /** At what index route arguments starts, so we can handle "route" version together with get/post/... */
    int routeArgsStart;

    AiohttpUrlDispatcherAddRouteCall() {
      this = urlDispathcerInstance().getMember("add_" + HTTP::httpVerbLower()).getACall() and
      routeArgsStart = 0
      or
      this = urlDispathcerInstance().getMember("add_route").getACall() and
      routeArgsStart = 1
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(routeArgsStart + 0), this.getArgByName("path")]
    }

    override DataFlow::Node getRequestHandlerArg() {
      result in [this.getArg(routeArgsStart + 1), this.getArgByName("handler")]
    }
  }

  /**
   * A route-setup from using `route` or any of `get`, `post`, etc. functions from `aiohttp.web`.
   *
   * Note that technically, this does not set up a route in itself (since it needs to be added to an application first).
   * However, modeling this way makes it easier, and we don't expect it to lead to many problems.
   */
  class AiohttpWebRouteCall extends AiohttpCoroutineRouteSetup, DataFlow::CallCfgNode {
    /** At what index route arguments starts, so we can handle "route" version together with get/post/... */
    int routeArgsStart;

    AiohttpWebRouteCall() {
      exists(string funcName |
        funcName = HTTP::httpVerbLower() and
        routeArgsStart = 0
        or
        funcName = "route" and
        routeArgsStart = 1
      |
        this = API::moduleImport("aiohttp").getMember("web").getMember(funcName).getACall()
      )
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(routeArgsStart + 0), this.getArgByName("path")]
    }

    override DataFlow::Node getRequestHandlerArg() {
      result in [this.getArg(routeArgsStart + 1), this.getArgByName("handler")]
    }
  }

  /** A route-setup from using a `route` or any of `get`, `post`, etc. decorators from a `aiohttp.web.RouteTableDef`. */
  class AiohttpRouteTableDefRouteCall extends AiohttpCoroutineRouteSetup, DataFlow::CallCfgNode {
    /** At what index route arguments starts, so we can handle "route" version together with get/post/... */
    int routeArgsStart;

    AiohttpRouteTableDefRouteCall() {
      exists(string decoratorName |
        decoratorName = HTTP::httpVerbLower() and
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

    override DataFlow::Node getRequestHandlerArg() { none() }

    override Function getARequestHandler() { result.getADecorator() = this.asExpr() }
  }
}
