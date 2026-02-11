import javascript

API::NewNode getAWebSocketInstance() { result instanceof ClientWebSocket::ClientSocket }

from DataFlow::Node handler
where
  handler = getAWebSocketInstance().getReturn().getMember("onmessage").asSource()
  or
  handler = getAWebSocketInstance().getAPropertyWrite("onmessage").getRhs()
select handler, "This is a WebSocket onmessage handler."
