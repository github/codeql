/**
 * Provides definitions and modelling for the `python-socketio` PyPI package.
 * See https://python-socketio.readthedocs.io/en/stable/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.PoorMansFunctionResolution

/**
 * Provides models for the `python-socketio` PyPI package.
 * See https://python-socketio.readthedocs.io/en/stable/.
 */
module SocketIO {
  /** An instance of a socketio `Server` or `AsyncServer`. */
  API::Node server() {
    result = API::moduleImport("socketio").getMember(["Server", "AsyncServer"]).getAnInstance()
  }

  API::Node serverEventAnnotation() {
    result = server().getMember("event")
    or
    result = server().getMember("on").getReturn()
  }

  private class EventHandler extends Http::Server::RequestHandler::Range {
    EventHandler() {
      serverEventAnnotation().getAValueReachableFromSource().asExpr() = this.getADecorator()
    }

    override Parameter getARoutedParameter() {
      result = this.getAnArg() and not result = this.getArg(0)
    }

    override string getFramework() { result = "socketio" }
  }

  private class CallbackArgument extends DataFlow::Node {
    CallbackArgument() {
      exists(DataFlow::CallCfgNode c | c = server().getMember(["emit", "send"]).getACall() |
        this = c.getArgByName("callback")
      )
      or
      exists(DataFlow::CallCfgNode c | c = server().getMember("on").getACall() |
        this = c.getArg(1) or
        this = c.getArgByName("handler")
      )
    }
  }

  private class CallbackHandler extends Http::Server::RequestHandler::Range {
    CallbackHandler() { any(CallbackArgument ca) = poorMansFunctionTracker(this) }

    override Parameter getARoutedParameter() {
      result = this.getAnArg() and not result = this.getArg(0)
    }

    override string getFramework() { result = "socketio" }
  }

  private class SocketIOCall extends RemoteFlowSource::Range {
    SocketIOCall() { this = server().getMember("call").getACall() }

    override string getSourceType() { result = "socketio call" }
  }
}
