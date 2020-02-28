/**
 * Provides classes for working with [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket) and [ws](https://github.com/websockets/ws).
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
 * Provides classes that model WebSockets clients.
 */
module ClientWebSocket {
  /**
   * A class that can be used to instantiate a WebSocket instance.
   */
  class SocketClass extends DataFlow::SourceNode {
    boolean isNode;

    SocketClass() {
      this = DataFlow::globalVarRef("WebSocket") and isNode = false
      or
      this = DataFlow::moduleImport("ws") and isNode = true
    }

    /**
     * Holds if this class is an import of the "ws" module.
     */
    predicate isNode() { isNode = true }
  }

  /**
   * A client WebSocket instance.
   */
  class ClientSocket extends EventEmitter::Range, DataFlow::SourceNode {
    SocketClass socketClass;

    ClientSocket() { this = socketClass.getAnInstantiation() }

    /**
     * Holds if this ClientSocket is created from the "ws" module.
     *
     * The predicate is used to differentiate where the behavior of the "ws" module differs from the native WebSocket in browsers.
     */
    predicate isNode() { socketClass.isNode() }
  }

  /**
   * A message sent from a WebSocket client.
   */
  class SendNode extends EventDispatch::Range, DataFlow::CallNode {
    override ClientSocket emitter;

    SendNode() { this = emitter.getAMemberCall("send") }

    override string getChannel() { result = channelName() }

    override DataFlow::Node getSentItem(int i) { i = 0 and result = this.getArgument(0) }

    override ServerWebSocket::ReceiveNode getAReceiver() { any() }
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
      emitter.isNode() and
      this = getAMessageHandler(emitter, EventEmitter::on())
    }

    override DataFlow::Node getReceivedItem(int i) { i = 0 and result = this.getParameter(0) }
  }
}

/**
 * Provides classes that model WebSocket servers.
 */
module ServerWebSocket {
  /**
   * A server WebSocket instance.
   */
  class ServerSocket extends EventEmitter::Range, DataFlow::SourceNode {
    ServerSocket() {
      exists(DataFlow::CallNode onCall |
        onCall =
          DataFlow::moduleImport("ws")
              .getAConstructorInvocation("Server")
              .getAMemberCall(EventEmitter::on()) and
        onCall.getArgument(0).mayHaveStringValue("connection")
      |
        this = onCall.getCallback(1).getParameter(0)
      )
    }
  }

  /**
   * A message sent from a WebSocket server.
   */
  class SendNode extends EventDispatch::Range, DataFlow::CallNode {
    override ServerSocket emitter;

    SendNode() { this = emitter.getAMemberCall("send") }

    override string getChannel() { result = channelName() }

    override DataFlow::Node getSentItem(int i) {
      i = 0 and
      result = getArgument(0)
    }

    override ClientWebSocket::ReceiveNode getAReceiver() { any() }
  }

  /**
   * A registration of an event handler that receives data from a WebSocket.
   */
  class ReceiveNode extends EventRegistration::Range, DataFlow::CallNode {
    override ServerSocket emitter;

    ReceiveNode() {
      this = emitter.getAMemberCall(EventEmitter::on()) and
      this.getArgument(0).mayHaveStringValue("message")
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
