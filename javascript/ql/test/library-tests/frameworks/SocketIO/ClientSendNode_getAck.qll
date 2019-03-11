import javascript

query predicate test_ClientSendNode_getAck(SocketIOClient::SendNode sn, DataFlow::FunctionNode res) {
  res = sn.getAck()
}
