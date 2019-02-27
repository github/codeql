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
  /** Gets a data flow node that creates a new socket.io server. */
  private DataFlow::SourceNode newServer() {
    result = DataFlow::moduleImport("socket.io").getAnInvocation()
    or
    // alias for `Server`
    result = DataFlow::moduleImport("socket.io").getAMemberCall("listen")
  }

  /** A data flow node that may produce (that is, create or return) a socket.io server. */
  class ServerNode extends DataFlow::SourceNode {
    ServerObject srv;

    ServerNode() {
      this = newServer() and
      srv = MkServer(this)
      or
      // invocation of a chainable method
      exists(ServerNode base, DataFlow::MethodCallNode mcn, string m |
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
        mcn = base.getAMethodCall(m) and
        // exclude getter versions
        exists(mcn.getAnArgument()) and
        this = mcn and
        srv = base.getServer()
      )
    }

    /** Gets the server to which this node refers. */
    ServerObject getServer() { result = srv }
  }

  /** A data flow node that may produce a namespace object. */
  class NamespaceNode extends DataFlow::SourceNode {
    NamespaceObject ns;

    NamespaceNode() {
      // namespace lookup
      exists(ServerNode srv |
        this = srv.getAPropertyRead("sockets") and
        ns = srv.getServer().getDefaultNamespace()
        or
        exists(DataFlow::MethodCallNode mcn, string path |
          mcn = srv.getAMethodCall("of") and
          mcn.getArgument(0).mayHaveStringValue(path) and
          this = mcn and
          ns = MkNamespace(srv.getServer(), path)
        )
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
        m = EventEmitter::chainableMethod()
      |
        exists(NamespaceNode base |
          this = base.getAMethodCall(m) and
          ns = base.getNamespace()
        )
        or
        // server objects forward these methods to their default namespace
        exists(ServerNode srv |
          this = srv.getAMethodCall(m) and
          ns = srv.getServer().getDefaultNamespace()
        )
      )
      or
      // invocation of chainable getter method
      exists(NamespaceNode base, string m |
        m = "json" or
        m = "local" or
        m = "volatile"
      |
        this = base.getAPropertyRead(m) and
        ns = base.getNamespace()
      )
    }

    /** Gets the namespace to which this node refers. */
    NamespaceObject getNamespace() { result = ns }
  }

  /** A data flow node that may produce a socket object. */
  class SocketNode extends DataFlow::SourceNode {
    NamespaceObject ns;

    SocketNode() {
      // callback accepting a socket
      exists(DataFlow::SourceNode base, string connect, DataFlow::MethodCallNode on |
        (
          ns = base.(ServerNode).getServer().getDefaultNamespace() or
          ns = base.(NamespaceNode).getNamespace()
        ) and
        (connect = "connect" or connect = "connection")
      |
        on = base.getAMethodCall(EventEmitter::on()) and
        on.getArgument(0).mayHaveStringValue(connect) and
        this = on.getCallback(1).getParameter(0)
      )
      or
      // invocation of a chainable method
      exists(SocketNode base, string m |
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
        m = EventEmitter::chainableMethod()
      |
        this = base.getAMethodCall(m) and
        ns = base.getNamespace()
      )
      or
      // invocation of a chainable getter method
      exists(SocketNode base, string m |
        m = "broadcast" or
        m = "json" or
        m = "local" or
        m = "volatile"
      |
        this = base.getAPropertyRead(m) and
        ns = base.getNamespace()
      )
    }

    /** Gets the namespace to which this socket belongs. */
    NamespaceObject getNamespace() { result = ns }
  }

  /**
   * A data flow node representing an API call that receives data from a client.
   */
  class ReceiveNode extends DataFlow::MethodCallNode {
    SocketNode socket;

    ReceiveNode() { this = socket.getAMethodCall(EventEmitter::on()) }

    /** Gets the socket through which data is received. */
    SocketNode getSocket() { result = socket }

    /** Gets the event name associated with the data, if it can be determined. */
    string getEventName() { getArgument(0).mayHaveStringValue(result) }

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

    /**
     * Gets the namespace to which data is sent.
     */
    NamespaceObject getNamespace() {
      result = base.(ServerNode).getServer().getDefaultNamespace() or
      result = base.(NamespaceNode).getNamespace() or
      result = base.(SocketNode).getNamespace()
    }

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

  /** A socket.io server, identified by its creation site. */
  private newtype TServer = MkServer(DataFlow::SourceNode nd) { nd = newServer() }

  /** A socket.io namespace, identified by its server and its path. */
  private newtype TNamespace =
    MkNamespace(ServerObject srv, string path) {
      path = "/"
      or
      exists(ServerNode nd | nd.getServer() = srv |
        nd.getAMethodCall("of").getArgument(0).mayHaveStringValue(path)
      )
    }

  /** A socket.io server. */
  class ServerObject extends TServer {
    DataFlow::SourceNode origin;

    ServerObject() { this = MkServer(origin) }

    /** Gets the data flow node where this server is created. */
    DataFlow::SourceNode getOrigin() { result = origin }

    /** Gets the default namespace of this server. */
    NamespaceObject getDefaultNamespace() { result = MkNamespace(this, "/") }

    /**
     * Holds if this server is created at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      origin.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /** Gets a textual representation of this server. */
    string toString() { result = "socket.io server" }
  }

  /** A socket.io namespace. */
  class NamespaceObject extends TNamespace {
    ServerObject srv;

    string path;

    NamespaceObject() { this = MkNamespace(srv, path) }

    /** Gets the server to which this namespace belongs. */
    ServerObject getServer() { result = srv }

    /** Gets the path of this namespace. */
    string getPath() { result = path }

    /** Gets a textual representation of this namespace. */
    string toString() { result = "socket.io namespace with path '" + path + "'" }
  }
}

/** Provides predicates for working with Node.js `EventEmitter`s. */
private module EventEmitter {
  /** Gets the name of a method on `EventEmitter` that returns `this`. */
  string chainableMethod() {
    result = "off" or
    result = "removeAllListeners" or
    result = "removeListener" or
    result = "setMaxListeners" or
    result = on()
  }

  /** Gets the name of a method on `EventEmitter` that registers an event handler. */
  string on() {
    result = "addListener" or
    result = "on" or
    result = "once" or
    result = "prependListener" or
    result = "prependOnceListener"
  }
}
