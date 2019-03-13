import javascript

query predicate test_SendNode_getSocket(SocketIO::SendNode sn, SocketIO::SocketNode res) {
  res = sn.getSocket()
}
