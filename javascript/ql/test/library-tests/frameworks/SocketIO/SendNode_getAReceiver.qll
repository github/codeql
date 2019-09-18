import javascript

query predicate test_SendNode_getAReceiver(SocketIO::SendNode sn, SocketIOClient::ReceiveNode res) {
  res = sn.getAReceiver()
}
