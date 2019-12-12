import javascript

query predicate test_ClientReceiveNode_getAck(
  SocketIOClient::ReceiveNode rn, SocketIOClient::RecieveCallback res
) {
  res.getReceiveNode() = rn
}
