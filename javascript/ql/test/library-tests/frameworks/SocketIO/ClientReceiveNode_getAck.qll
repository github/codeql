import javascript

query predicate test_ClientReceiveNode_getAck(
  SocketIOClient::ReceiveNode rn, SocketIOClient::ReceiveCallback res
) {
  res.getReceiveNode() = rn
}
