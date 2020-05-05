/**
 * Provides classes for working with [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket), [ws](https://github.com/websockets/ws), and [SockJS](http://sockjs.org).
 *
 * The model is based on the EventEmitter model, and there is therefore a
 * data-flow step from where a WebSocket event is sent to where the message
 * is received.
 *
 * Data flow is modeled both from clients to servers, and from servers to clients.
 * The model models that clients can send messages to all servers, and servers can send messages to all clients.
 */

import javascript

/**
 * Gets the channel name used throughout this WebSocket model.
 * WebSockets don't have a concept of channels, and therefore a singleton name is used.
 * The name can be anything, as long as it is used consistently in this WebSocket model.
 */
private string channelName() { result = "message" }

/**
 * The names of the libraries modelled in this file.
 */
private module LibraryNames {
  string sockjs() { result = "SockJS" }

  string websocket() { result = "WebSocket" }

  string ws() { result = "ws" }

  class LibraryName extends string {
    LibraryName() { this = sockjs() or this = websocket() or this = ws() }
  }
}

/**
 * Holds if the websocket library named `client` can send a message to the library named `server`.
 * Both `client` and `server` are library names defined in `LibraryNames`.
 */
private predicate areLibrariesCompatible(
  LibraryNames::LibraryName client, LibraryNames::LibraryName server
) {
  // sockjs is a WebSocket emulating library, but not actually an implementation of WebSockets.
  client = LibraryNames::sockjs() and server = LibraryNames::sockjs()
  or
  server = LibraryNames::ws() and
  (client = LibraryNames::ws() or client = LibraryNames::websocket())
}

/**
 * Provides classes that model WebSockets clients.
 */
module ClientWebSocket {
  private import LibraryNames

  /**
   * A class that can be used to instantiate a WebSocket instance.
   */
  class SocketClass extends DataFlow::SourceNode {
    LibraryName library; // the name of the WebSocket library. Can be one of the libraries defined in `LibraryNames`.

    SocketClass() {
      this = DataFlow::globalVarRef("WebSocket") and library = websocket()
      or
      this = DataFlow::moduleImport("ws") and library = ws()
      or
      // the sockjs-client library:https://www.npmjs.com/package/sockjs-client
      library = sockjs() and
      (
        this = DataFlow::moduleImport("sockjs-client") or
        this = DataFlow::globalVarRef("SockJS")
      )
    }

    /**
     * Gets the WebSocket library name.
     */
    LibraryName getLibrary() { result = library }
  }

  /**
   * A client WebSocket instance.
   */
  class ClientSocket extends EventEmitter::Range, DataFlow::SourceNode {
    SocketClass socketClass;

    ClientSocket() { this = socketClass.getAnInstantiation() }

    /**
     * Gets the WebSocket library name.
     */
    LibraryName getLibrary() { result = socketClass.getLibrary() }
  }

  /**
   * A message sent from a WebSocket client.
   */
  class SendNode extends EventDispatch::Range, DataFlow::CallNode {
    override ClientSocket emitter;

    SendNode() { this = emitter.getAMemberCall("send") }

    override string getChannel() { result = channelName() }

    override DataFlow::Node getSentItem(int i) { i = 0 and result = this.getArgument(0) }

    override ServerWebSocket::ReceiveNode getAReceiver() {
      areLibrariesCompatible(emitter.getLibrary(),
        result.getEmitter().(ServerWebSocket::ServerSocket).getLibrary())
    }
  }

  /**
   * A handler that is registered to receive messages from a WebSocket.
   */
  abstract class ReceiveNode extends EventRegistration::Range, DataFlow::FunctionNode {
    override ClientSocket emitter;

    override string getChannel() { result = channelName() }
  }

  /**
   * Gets a handler, that is registered using method `methodName` and receives messages sent to `emitter`.
   */
  private DataFlow::FunctionNode getAMessageHandler(
    ClientWebSocket::ClientSocket emitter, string methodName
  ) {
    exists(DataFlow::CallNode call |
      call = emitter.getAMemberCall(methodName) and
      call.getArgument(0).mayHaveStringValue("message") and
      result = call.getCallback(1)
    )
  }

  /**
   * A handler that receives a message using the WebSocket API.
   * The WebSocket API is used both by the WebSocket library in browsers, and the same API is also implemented as part of the "ws" library.
   * This class therefore models both the WebSocket library, and a subset of the "ws" library.
   */
  private class WebSocketReceiveNode extends ClientWebSocket::ReceiveNode {
    WebSocketReceiveNode() {
      this = getAMessageHandler(emitter, "addEventListener")
      or
      this = emitter.getAPropertyWrite("onmessage").getRhs()
    }

    override DataFlow::Node getReceivedItem(int i) {
      i = 0 and result = this.getParameter(0).getAPropertyRead("data")
    }
  }

  /**
   * A handler that receives a message using the API from the "ws" library.
   * The "ws" library additionally implements the WebSocket API, which is modeled in the `WebSocketReceiveNode` class.
   */
  private class WSReceiveNode extends ClientWebSocket::ReceiveNode {
    WSReceiveNode() {
      emitter.getLibrary() = ws() and
      this = getAMessageHandler(emitter, EventEmitter::on())
    }

    override DataFlow::Node getReceivedItem(int i) { i = 0 and result = this.getParameter(0) }
  }
}

/**
 * Provides classes that model WebSocket servers.
 */
module ServerWebSocket {
  private import LibraryNames

  /**
   * Gets a server created by a library named `library`.
   */
  DataFlow::SourceNode getAServer(LibraryName library) {
    library = ws() and
    result = DataFlow::moduleImport("ws").getAConstructorInvocation("Server")
    or
    library = sockjs() and
    result = DataFlow::moduleImport("sockjs").getAMemberCall("createServer")
  }

  /**
   * A server WebSocket instance.
   */
  class ServerSocket extends EventEmitter::Range, DataFlow::SourceNode {
    LibraryName library;

    ServerSocket() {
      exists(DataFlow::CallNode onCall |
        onCall = getAServer(library).getAMemberCall(EventEmitter::on()) and
        onCall.getArgument(0).mayHaveStringValue("connection")
      |
        this = onCall.getCallback(1).getParameter(0)
      )
    }

    /**
     * Gets the name of the library that created this server socket.
     */
    LibraryName getLibrary() { result = library }
  }

  /**
   * A message sent from a WebSocket server.
   */
  class SendNode extends EventDispatch::Range, DataFlow::CallNode {
    override ServerSocket emitter;

    SendNode() {
      emitter.getLibrary() = ws() and
      this = emitter.getAMemberCall("send")
      or
      emitter.getLibrary() = sockjs() and
      this = emitter.getAMemberCall("write")
    }

    override string getChannel() { result = channelName() }

    override DataFlow::Node getSentItem(int i) {
      i = 0 and
      result = getArgument(0)
    }

    override ClientWebSocket::ReceiveNode getAReceiver() {
      areLibrariesCompatible(result.getEmitter().(ClientWebSocket::ClientSocket).getLibrary(),
        emitter.getLibrary())
    }
  }

  /**
   * A registration of an event handler that receives data from a WebSocket.
   */
  class ReceiveNode extends EventRegistration::Range, DataFlow::CallNode {
    override ServerSocket emitter;

    ReceiveNode() {
      exists(string eventName |
        emitter.getLibrary() = ws() and eventName = "message"
        or
        emitter.getLibrary() = sockjs() and eventName = "data"
      |
        this = emitter.getAMemberCall(EventEmitter::on()) and
        this.getArgument(0).mayHaveStringValue(eventName)
      )
    }

    override string getChannel() { result = channelName() }

    override DataFlow::Node getReceivedItem(int i) {
      i = 0 and
      result = this.getCallback(1).getParameter(0)
    }
  }

  /**
   * A data flow node representing data received from a client, viewed as remote user input.
   */
  private class ReceivedItemAsRemoteFlow extends RemoteFlowSource {
    ReceivedItemAsRemoteFlow() { this = any(ReceiveNode rercv).getReceivedItem(_) }

    override string getSourceType() { result = "WebSocket client data" }

    override predicate isUserControlledObject() { any() }
  }
}
