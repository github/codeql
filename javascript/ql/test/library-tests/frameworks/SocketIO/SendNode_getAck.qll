import javascript

query predicate test_SendNode_getAck(SocketIO::SendNode sn, DataFlow::FunctionNode res) {
  res = sn.getAck()
}
