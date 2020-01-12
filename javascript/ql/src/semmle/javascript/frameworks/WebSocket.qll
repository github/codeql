/**
 * Provides classes for working with [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket).
 *
 * The model is based on the EventEmitter model, and there a therefore a
 * data-flow step from where a WebSocket event is send to where the message
 * is received.
 *
 * WebSockets include no concept of channels, therefore every client can send
 * to every server (and vice versa).
 */

import javascript

/**
 * Gets the channel name used throughout this WebSocket model.
 * WebSockets don't have a concept of channels, and therefore a singleton name is used.
 * The name can be anything, as long as it is used consistently in this WebSocket model.
 */
private string channelName() { result = "message" }

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
     * Holds if this class an import of the "ws" module.
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
   * Gets a methodName that can be used to register a listener for WebSocket messages on a given socket.
   */
  string getARegisterMethodName(ClientSocket socket) {
    result = "addEventListener"
    or
    socket.isNode() and
    result = EventEmitter::on()
  }

  /**
   * A handler that is registered to receive messages from a WebSocket.
   *
   * If the registration happens with the "addEventListener" method or the "onmessage" setter property, then the handler receives an event with a "data" property.
   * Otherwise the handler receives the data directly.
   *
   * This confusing API is caused by the "ws" library only mostly using their own API, where event objects are not used.
   * But the "ws" library additionally supports the WebSocket API from browsers, which exclusively use event objects with a "data" property.
   */
  class ReceiveNode extends EventRegistration::Range, DataFlow::FunctionNode {
    override ClientSocket emitter;
    boolean receivesEvent;

    ReceiveNode() {
      exists(DataFlow::CallNode call, string methodName |
        methodName = getARegisterMethodName(emitter) and
        call = emitter.getAMemberCall(methodName) and
        call.getArgument(0).mayHaveStringValue("message") and
        this = call.getCallback(1) and
        if methodName = "addEventListener" then receivesEvent = true else receivesEvent = false
      )
      or
      this = emitter.getAPropertyWrite("onmessage").getRhs() and
      receivesEvent = true
    }

    override string getChannel() { result = channelName() }

    override DataFlow::Node getReceivedItem(int i) {
      i = 0 and
      result = this.getParameter(0).getAPropertyRead("data") and
      receivesEvent = true
      or
      i = 0 and
      result = this.getParameter(0) and
      receivesEvent = false
    }
  }
}

module ServerWebSocket {
  /**
   * A server WebSocket instance.
   */
  class ServerSocket extends EventEmitter::Range, DataFlow::SourceNode {
    ServerSocket() {
      exists(DataFlow::CallNode onCall |
        onCall = DataFlow::moduleImport("ws")
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
