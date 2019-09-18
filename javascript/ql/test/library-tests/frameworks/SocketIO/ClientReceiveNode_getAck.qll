import javascript

query predicate test_ClientReceiveNode_getAck(
  SocketIOClient::ReceiveNode rn, DataFlow::SourceNode res
) {
  res = rn.getAck()
}
