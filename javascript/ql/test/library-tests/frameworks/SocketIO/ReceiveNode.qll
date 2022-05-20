import javascript

query predicate test_ReceiveNode(SocketIO::ReceiveNode rn, SocketIO::SocketNode res) {
  res = rn.getSocket()
}
