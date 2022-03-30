import javascript

query predicate test_SendNode_getSentItem(SocketIO::SendNode sn, int i, DataFlow::Node res) {
  res = sn.getSentItem(i)
}
