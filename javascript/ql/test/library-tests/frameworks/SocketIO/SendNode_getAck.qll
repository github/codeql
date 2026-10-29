import javascript

query predicate test_SendNode_getAck(SocketIO::SendNode sn, SocketIO::SendCallback res) {
  res.getSendNode() = sn
}
