import javascript

query predicate test_ReceiveNode_getASender(SocketIO::ReceiveNode rn, SocketIOClient::SendNode res) {
  res.getAReceiver() = rn
}
