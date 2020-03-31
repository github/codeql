import javascript

query predicate test_ClientReceiveNode_getASender(
  SocketIOClient::ReceiveNode rn, SocketIO::SendNode res
) {
  res.getAReceiver() = rn
}
