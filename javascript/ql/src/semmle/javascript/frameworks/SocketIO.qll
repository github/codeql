/**
 * Provides classes for working with [socket.io](https://socket.io).
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * Provides classes for working with server-side socket.io code.
 *
 * We model three concepts: servers, namespaces, and sockets. A server
 * has one or more namespaces associated with it, each identified by
 * a path name. There is always a default namespace associated with the
 * path "/". Data flows between client and server side through sockets,
 * with each socket belonging to a namespace on a server.
 */
module SocketIO {
  /** Gets the name of a method on `EventEmitter` that returns `this`. */
  private string chainableEventEmitterMethod() {
    result = "off" or
    result = "on" or
    result = "once" or
    result = "prependListener" or
    result = "prependOnceListener" or
    result = "removeAllListeners" or
    result = "removeListener" or
    result = "setMaxListeners"
  }

  /** A data flow node that may produce (that is, create or return) a socket.io server. */
  class ServerNode extends DataFlow::SourceNode {
    ServerNode() {
      // server creation
      this = DataFlow::moduleImport("socket.io").getAnInvocation()
      or
      // alias for `Server`
      this = DataFlow::moduleImport("socket.io").getAMemberCall("listen")
      or
      // invocation of a chainable method
      exists(DataFlow::MethodCallNode mcn, string m |
        m = "adapter" or
        m = "attach" or
        m = "bind" or
        m = "listen" or
        m = "onconnection" or
        m = "origins" or
        m = "path" or
        m = "serveClient" or
        m = "set"
      |
        mcn = any(ServerNode srv).getAMethodCall(m) and
        // exclude getter versions
        not mcn.getNumArgument() = 0 and
        this = mcn
      )
    }
  }

  /** A data flow node that may produce a namespace object. */
  class NamespaceNode extends DataFlow::SourceNode {
    NamespaceNode() {
      // namespace lookup
      exists(ServerNode srv |
        this = srv.getAPropertyRead("sockets")
        or
        this = srv.getAMethodCall("of")
      )
      or
      // invocation of a chainable method
      exists(string m |
        m = "binary" or
        m = "clients" or
        m = "compress" or
        m = "emit" or
        m = "in" or
        m = "send" or
        m = "to" or
        m = "use" or
        m = "write" or
        m = chainableEventEmitterMethod()
      |
        this = any(NamespaceNode ns).getAMethodCall(m)
        or
        // server objects forward these methods to their default namespace
        this = any(ServerNode srv).getAMethodCall(m)
      )
      or
      // invocation of chainable getter method
      exists(string m |
        m = "json" or
        m = "local" or
        m = "volatile"
      |
        this = any(NamespaceNode base).getAPropertyRead(m)
      )
    }
  }

  /** A data flow node that may produce a socket object. */
  class SocketNode extends DataFlow::SourceNode {
    SocketNode() {
      // callback accepting a socket
      exists(DataFlow::SourceNode base, string connect, DataFlow::MethodCallNode on |
        (base instanceof ServerNode or base instanceof NamespaceNode) and
        (connect = "connect" or connect = "connection")
      |
        on = base.getAMethodCall("on") and
        on.getArgument(0).mayHaveStringValue(connect) and
        this = on.getCallback(1).getParameter(0)
      )
      or
      // invocation of a chainable method
      exists(string m |
        m = "binary" or
        m = "compress" or
        m = "disconnect" or
        m = "emit" or
        m = "in" or
        m = "join" or
        m = "leave" or
        m = "send" or
        m = "to" or
        m = "use" or
        m = "write" or
        m = chainableEventEmitterMethod()
      |
        this = any(SocketNode base).getAMethodCall(m)
      )
      or
      // invocation of a chainable getter method
      exists(string m |
        m = "broadcast" or
        m = "json" or
        m = "local" or
        m = "volatile"
      |
        this = any(SocketNode base).getAPropertyRead(m)
      )
    }
  }

  /**
   * A data flow node representing an API call that receives data from a client.
   */
  class ReceiveNode extends DataFlow::MethodCallNode {
    SocketNode socket;

    DataFlow::Node eventName;

    ReceiveNode() {
      exists(string on |
        on = "addListener" or
        on = "on" or
        on = "once" or
        on = "prependListener" or
        on = "prependOnceListener"
      |
        this = socket.getAMethodCall(on) and
        eventName = getArgument(0)
      )
    }

    /** Gets the socket through which data is received. */
    SocketNode getSocket() { result = socket }

    /** Gets the event name associated with the data, if it can be determined. */
    string getEventName() { eventName.mayHaveStringValue(result) }

    /** Gets a data flow node representing data received from a client. */
    DataFlow::SourceNode getAReceivedItem() { result = getCallback(1).getAParameter() }
  }

  /**
   * A data flow node representing data received from a client, viewed as remote user input.
   */
  private class ReceivedItemAsRemoteFlow extends RemoteFlowSource {
    ReceivedItemAsRemoteFlow() { this = any(ReceiveNode rercv).getAReceivedItem() }

    override string getSourceType() { result = "socket.io client data" }

    override predicate isUserControlledObject() { any() }
  }

  /**
   * A data flow node representing an API call that sends data to a client.
   */
  class SendNode extends DataFlow::MethodCallNode {
    DataFlow::SourceNode base;

    int firstDataIndex;

    SendNode() {
      exists(string m |
        (base instanceof ServerNode or base instanceof NamespaceNode or base instanceof SocketNode) and
        this = base.getAMethodCall(m)
      |
        // a call to `emit`
        m = "emit" and
        firstDataIndex = 1
        or
        // a call to `send` or `write`
        (m = "send" or m = "write") and
        firstDataIndex = 0
      )
    }

    /**
     * Gets the socket through which data is sent to the client.
     *
     * This predicate is not defined for broadcasting sends.
     */
    SocketNode getSocket() { result = base }

    /** Gets the event name associated with the data, if it can be determined. */
    string getEventName() {
      if firstDataIndex = 1 then getArgument(0).mayHaveStringValue(result) else result = "message"
    }

    /** Gets a data flow node representing data sent to the client. */
    DataFlow::Node getASentItem() {
      exists(int i |
        result = getArgument(i) and
        i >= firstDataIndex and
        // exclude last argument if it is a callback
        (
          i < getNumArgument() - 1 or
          not result.analyze().getTheType() = TTFunction()
        )
      )
    }

    /** Gets the acknowledgment callback, if any. */
    DataFlow::FunctionNode getAck() {
      // acknowledgments are only available when sending through a socket
      exists(getSocket()) and
      result = getLastArgument().getALocalSource()
    }
  }
}
