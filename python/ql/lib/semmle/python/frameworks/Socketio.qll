/**
 * Provides definitions and modeling for the `python-socketio` PyPI package.
 * See https://python-socketio.readthedocs.io/en/stable/.
 */

private import python
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
  /** Provides models for socketio `Server` and `AsyncServer` classes. */
  module Server {
    /** Gets an instance of a socketio `Server` or `AsyncServer`. */
    API::Node server() {
      result = API::moduleImport("socketio").getMember(["Server", "AsyncServer"]).getAnInstance()
    }

    /** Gets a decorator that indicates a socketio event handler. */
    private API::Node serverEventAnnotation() {
      result = server().getMember("event")
      or
      result = server().getMember("on").getReturn()
    }

    private class EventHandler extends Http::Server::RequestHandler::Range {
      EventHandler() {
        serverEventAnnotation().getAValueReachableFromSource().asExpr() = this.getADecorator()
        or
        exists(DataFlow::CallCfgNode c, DataFlow::Node arg |
          c = server().getMember("on").getACall()
        |
          (
            arg = c.getArg(1)
            or
            arg = c.getArgByName("handler")
          ) and
          poorMansFunctionTracker(this) = arg
        )
      }

      override Parameter getARoutedParameter() {
        result = this.getAnArg() and
        not result = this.getArg(0) // First parameter is `sid`, which is not a remote flow source as it cannot be controlled by the client.
      }

      override string getFramework() { result = "socketio" }
    }

    private class CallbackArgument extends DataFlow::Node {
      CallbackArgument() {
        exists(DataFlow::CallCfgNode c |
          c = [server(), Namespace::instance()].getMember(["emit", "send"]).getACall()
        |
          this = c.getArgByName("callback")
        )
      }
    }

    private class CallbackHandler extends Http::Server::RequestHandler::Range {
      CallbackHandler() { any(CallbackArgument ca) = poorMansFunctionTracker(this) }

      override Parameter getARoutedParameter() { result = this.getAnArg() }

      override string getFramework() { result = "socketio" }
    }

    private class SocketIOCall extends RemoteFlowSource::Range {
      SocketIOCall() { this = [server(), Namespace::instance()].getMember("call").getACall() }

      override string getSourceType() { result = "socketio call" }
    }
  }

  /** Provides modeling for socketio server Namespace/AsyncNamespace classes. */
  module Namespace {
    /** Gets a reference to the `socketio.Namespace` or `socketio.AsyncNamespace` classes or any subclass. */
    API::Node subclassRef() {
      result =
        API::moduleImport("socketio").getMember(["Namespace", "AsyncNamespace"]).getASubclass*()
    }

    /** Gets a reference to an instance of a subclass of `socketio.Namespace` or `socketio.AsyncNamespace`. */
    API::Node instance() {
      result = subclassRef().getAnInstance()
      or
      result = subclassRef().getAMember().getSelfParameter()
    }

    /** A socketio Namespace class. */
    class NamespaceClass extends Class {
      NamespaceClass() { this.getABase() = subclassRef().asSource().asExpr() }

      /** Gets a handler for socketio events. */
      Function getAnEventHandler() {
        result = this.getAMethod() and
        result.getName().matches("on_%")
      }
    }

    private class NamespaceEventHandler extends Http::Server::RequestHandler::Range {
      NamespaceEventHandler() { this = any(NamespaceClass nc).getAnEventHandler() }

      override Parameter getARoutedParameter() {
        result = this.getAnArg() and
        not result = this.getArg(0) and
        not result = this.getArg(1) // First 2 parameters are `self` and `sid`.
      }

      override string getFramework() { result = "socketio" }
    }
  }
}
