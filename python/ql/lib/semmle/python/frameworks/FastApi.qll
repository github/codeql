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

/**
 * Provides models for the `fastapi` PyPI package.
 * See https://fastapi.tiangolo.com/.
 */
private module FastApi {
  /**
   * Provides models for FastAPI applications (an instance of `fastapi.FastAPI`).
   */
  module App {
    /** Gets a reference to a FastAPI application (an instance of `fastapi.FastAPI`). */
    API::Node instance() { result = API::moduleImport("fastapi").getMember("FastAPI").getReturn() }
  }

  /**
   * Provides models for the `fastapi.APIRouter` class
   *
   * See https://fastapi.tiangolo.com/tutorial/bigger-applications/.
   */
  module APIRouter {
    /** Gets a reference to an instance of `fastapi.APIRouter`. */
    API::Node instance() {
      result = API::moduleImport("fastapi").getMember("APIRouter").getReturn()
    }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
  /**
   * A call to a method like `get` or `post` on a FastAPI application.
   *
   * See https://fastapi.tiangolo.com/tutorial/first-steps/#define-a-path-operation-decorator
   */
  private class FastApiRouteSetup extends HTTP::Server::RouteSetup::Range, DataFlow::CallCfgNode {
    FastApiRouteSetup() {
      exists(string routeAddingMethod |
        routeAddingMethod = HTTP::httpVerbLower()
        or
        routeAddingMethod = "api_route"
      |
        this = App::instance().getMember(routeAddingMethod).getACall()
        or
        this = APIRouter::instance().getMember(routeAddingMethod).getACall()
      )
    }

    override Parameter getARoutedParameter() {
      // this will need to be refined a bit, since you can add special parameters to
      // your request handler functions that are used to pass in the response. There
      // might be other special cases as well, but as a start this is not too far off
      // the mark.
      result = this.getARequestHandler().getArgByName(_)
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("path")]
    }

    override Function getARequestHandler() { result.getADecorator().getAFlowNode() = node }

    override string getFramework() { result = "FastAPI" }
  }

  // ---------------------------------------------------------------------------
  // Response modeling
  // ---------------------------------------------------------------------------
  /**
   * Implicit response from returns of FastAPI request handlers
   */
  private class FastApiRequestHandlerReturn extends HTTP::Server::HttpResponse::Range,
    DataFlow::CfgNode {
    FastApiRequestHandlerReturn() {
      exists(Function requestHandler |
        requestHandler = any(FastApiRouteSetup rs).getARequestHandler() and
        node = requestHandler.getAReturnValueFlowNode()
      )
    }

    override DataFlow::Node getBody() { result = this }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "application/json" }
  }
}
