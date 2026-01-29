/**
 * Provides definitions and modeling for the `websockets` PyPI package.
 *
 * See https://websockets.readthedocs.io/en/stable/
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * Provides models for the `websockets` PyPI package.
 * See https://websockets.readthedocs.io/en/stable/
 */
module Websockets {
  private class HandlerArg extends DataFlow::Node {
    HandlerArg() {
      exists(DataFlow::CallCfgNode c |
        c =
          API::moduleImport("websockets")
              .getMember(["asyncio", "sync"])
              .getMember("server")
              .getMember(["serve", "unix_serve"])
              .getACall()
      |
        (this = c.getArg(0) or this = c.getArgByName("handler"))
      )
    }
  }

  /** A websocket handler that is passed to `serve`. */
  // TODO: handlers defined via route maps, e.g. through `websockets.asyncio.router.route`, are more complex to handle.
  class WebSocketHandler extends Http::Server::RequestHandler::Range {
    WebSocketHandler() { poorMansFunctionTracker(this) = any(HandlerArg a) }

    override Parameter getARoutedParameter() { result = this.getAnArg() }

    override string getFramework() { result = "websockets" }
  }

  /** Provides taint models for instances of `ServerConnection` objects passed to websocket handlers. */
  module ServerConnection {
    /**
     * A source of instances of `websockets.asyncio.ServerConnection` and `websockets.sync.ServerConnection`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `ServerConnection::instance()` to get references to instances of `websockets.asyncio.ServerConnection` and `websockets.sync.ServerConnection`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `websockets.asyncio.ServerConnection` or `websockets.sync.ServerConnection`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `websockets.asyncio.ServerConnection` or `websockets.sync.ServerConnection`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    private class HandlerParam extends DataFlow::Node, InstanceSource {
      HandlerParam() { exists(WebSocketHandler h | this = DataFlow::parameterNode(h.getArg(0))) }
    }

    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "websockets.asyncio.ServerConnection" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getAsyncMethodName() { result = ["recv", "recv_streaming"] }

      override string getMethodName() { result = ["recv", "recv_streaming"] }
    }
  }
}
