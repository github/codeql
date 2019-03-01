/**
 * Provides classes for working with [socket.io](https://socket.io).
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * Provides classes for working with server-side socket.io code
 * (npm package `socket.io`).
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

    /** Gets the `i`th parameter through which data is received from a client. */
    DataFlow::SourceNode getReceivedItem(int i) {
      exists(DataFlow::FunctionNode cb | cb = getCallback(1) and result = cb.getParameter(i) |
        // exclude last parameter if it looks like a callback
        result != cb.getLastParameter() or not exists(result.getAnInvocation())
      )
    }

    /** Gets a data flow node representing data received from a client. */
    DataFlow::SourceNode getAReceivedItem() { result = getReceivedItem(_) }

    /** Gets the acknowledgment callback, if any. */
    DataFlow::SourceNode getAck() {
      result = getCallback(1).getLastParameter() and
      exists(result.getAnInvocation())
    }

    /** Gets a client-side node that may be sending the data received here. */
    SocketIOClient::SendNode getASender() {
      result.getSocket().getATargetNamespace() = getSocket().getNamespace() and
      not result.getEventName() != getEventName()
    }
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

    /** Gets the `i`th argument through which data is sent to the client. */
    DataFlow::Node getSentItem(int i) {
      result = getArgument(i + firstDataIndex) and
      i >= 0 and
      (
        // exclude last argument if it looks like a callback
        result != getLastArgument() or not exists(getAck())
      )
    }

    /** Gets a data flow node representing data sent to the client. */
    DataFlow::Node getASentItem() { result = getSentItem(_) }

    /** Gets the acknowledgment callback, if any. */
    DataFlow::FunctionNode getAck() {
      // acknowledgments are only available when sending through a socket
      exists(getSocket()) and
      result = getLastArgument().getALocalSource()
    }

    /** Gets a client-side node that may be receiving the data sent here. */
    SocketIOClient::ReceiveNode getAReceiver() {
      result.getSocket().getATargetNamespace() = getNamespace() and
      not result.getEventName() != getEventName()
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

    /** Gets the namespace with the given path of this server. */
    NamespaceObject getNamespace(string path) { result = MkNamespace(this, path) }

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

/**
 * Provides classes for working with client-side socket.io code
 * (npm package `socket.io-client`).
 */
module SocketIOClient {
  /** A data flow node that may produce a socket object. */
  class SocketNode extends DataFlow::SourceNode {
    DataFlow::InvokeNode invk;

    SocketNode() {
      exists(DataFlow::SourceNode io |
        io = DataFlow::globalVarRef("io") or
        io = DataFlow::globalVarRef("io").getAPropertyRead("connect") or
        io = DataFlow::moduleImport("socket.io-client") or
        io = DataFlow::moduleMember("socket.io-client", "connect")
      |
        invk = io.getAnInvocation() and
        this = invk
      )
    }

    /** Gets the path of the namespace this socket belongs to, if it can be determined. */
    string getNamespacePath() {
      // the path name of the specified URL
      exists(string url, string pathRegex |
        invk.getArgument(0).mayHaveStringValue(url) and
        pathRegex = "(?<!/)/(?!/)[^?#]*"
      |
        result = url.regexpFind(pathRegex, 0, _)
        or
        // if the URL does not specify an explicit path, it defaults to "/"
        not exists(url.regexpFind(pathRegex, _, _)) and
        result = "/"
      )
      or
      // if no URL is specified, the path defaults to "/"
      not exists(invk.getArgument(0)) and
      result = "/"
    }

    /** Gets a server this socket may be communicating with. */
    SocketIO::ServerObject getATargetServer() {
      exists(NPMPackage pkg |
        result.getOrigin().getFile() = pkg.getAFile() and
        this.getFile() = pkg.getAFile()
      |
        not exists(getNamespacePath()) or
        exists(result.getNamespace(getNamespacePath()))
      )
    }

    /** Gets a namespace this socket may be communicating with. */
    SocketIO::NamespaceObject getATargetNamespace() {
      result = getATargetServer().getNamespace(getNamespacePath())
      or
      // if the namespace of this socket cannot be determined, overapproximate
      not exists(getNamespacePath()) and
      result = getATargetServer().getNamespace(_)
    }

    /** Gets a server-side socket this client-side socket may be communicating with. */
    SocketIO::SocketNode getATargetSocket() { result.getNamespace() = getATargetNamespace() }
  }

  /**
   * A data flow node representing an API call that receives data from the server.
   */
  class ReceiveNode extends DataFlow::MethodCallNode {
    SocketNode socket;

    ReceiveNode() { this = socket.getAMethodCall(EventEmitter::on()) }

    /** Gets the socket through which data is received. */
    SocketNode getSocket() { result = socket }

    /** Gets the event name associated with the data, if it can be determined. */
    string getEventName() { getArgument(0).mayHaveStringValue(result) }

    /** Gets the `i`th parameter through which data is received from the server. */
    DataFlow::SourceNode getReceivedItem(int i) {
      exists(DataFlow::FunctionNode cb | cb = getCallback(1) and result = cb.getParameter(i) |
        // exclude the last parameter if it looks like a callback
        result != cb.getLastParameter() or not exists(result.getAnInvocation())
      )
    }

    /** Gets a data flow node representing data received from the server. */
    DataFlow::SourceNode getAReceivedItem() { result = getReceivedItem(_) }

    /** Gets the acknowledgment callback, if any. */
    DataFlow::SourceNode getAck() {
      result = getCallback(1).getLastParameter() and
      exists(result.getAnInvocation())
    }

    /** Gets a server-side node that may be sending the data received here. */
    SocketIO::SendNode getASender() {
      result.getNamespace() = getSocket().getATargetNamespace() and
      not result.getEventName() != getEventName()
    }
  }

  /**
   * A data flow node representing an API call that sends data to the server.
   */
  class SendNode extends DataFlow::MethodCallNode {
    SocketNode base;

    int firstDataIndex;

    SendNode() {
      exists(string m | this = base.getAMethodCall(m) |
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
     * Gets the socket through which data is sent to the server.
     */
    SocketNode getSocket() { result = base }

    /**
     * Gets the path of the namespace to which data is sent, if it can be determined.
     */
    string getNamespacePath() { result = base.getNamespacePath() }

    /** Gets the event name associated with the data, if it can be determined. */
    string getEventName() {
      if firstDataIndex = 1 then getArgument(0).mayHaveStringValue(result) else result = "message"
    }

    /** Gets the `i`th argument through which data is sent to the server. */
    DataFlow::Node getSentItem(int i) {
      result = getArgument(i + firstDataIndex) and
      i >= 0 and
      (
        // exclude last argument if it looks like a callback
        result != getLastArgument() or not exists(getAck())
      )
    }

    /** Gets a data flow node representing data sent to the server. */
    DataFlow::Node getASentItem() { result = getSentItem(_) }

    /** Gets the acknowledgment callback, if any. */
    DataFlow::FunctionNode getAck() { result = getLastArgument().getALocalSource() }

    /** Gets a server-side node that may be receiving the data sent here. */
    SocketIO::ReceiveNode getAReceiver() {
      result.getSocket().getNamespace() = getSocket().getATargetNamespace() and
      not result.getEventName() != getEventName()
    }
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

/** A data flow step through socket.io sockets. */
private class SocketIoStep extends DataFlow::AdditionalFlowStep {
  DataFlow::Node pred;

  DataFlow::Node succ;

  SocketIoStep() {
    (
      exists(SocketIO::SendNode send, SocketIOClient::ReceiveNode recv, int i |
        recv = send.getAReceiver()
      |
        pred = send.getSentItem(i) and
        succ = recv.getReceivedItem(i)
        or
        pred = recv.getAck().getACall().getArgument(i) and
        succ = send.getAck().getParameter(i)
      )
      or
      exists(SocketIOClient::SendNode send, SocketIO::ReceiveNode recv, int i |
        recv = send.getAReceiver()
      |
        pred = send.getSentItem(i) and
        succ = recv.getReceivedItem(i)
        or
        pred = recv.getAck().getACall().getArgument(i) and
        succ = send.getAck().getParameter(i)
      )
    ) and
    this = pred
  }

  override predicate step(DataFlow::Node predNode, DataFlow::Node succNode) {
    predNode = pred and succNode = succ
  }
}
