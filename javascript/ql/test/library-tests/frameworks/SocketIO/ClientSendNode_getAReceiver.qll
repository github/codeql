import javascript

query predicate test_ClientSendNode_getAReceiver(
  SocketIOClient::SendNode sn, SocketIO::ReceiveNode res
) {
  res = sn.getAReceiver()
}
