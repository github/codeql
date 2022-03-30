import javascript

query predicate test_ClientSendNode_getAck(
  SocketIOClient::SendNode sn, SocketIOClient::SendCallback res
) {
  res.getSendNode() = sn
}
