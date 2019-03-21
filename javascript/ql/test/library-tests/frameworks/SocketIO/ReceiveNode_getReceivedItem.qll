import javascript

query predicate test_ReceiveNode_getReceivedItem(
  SocketIO::ReceiveNode rn, int i, DataFlow::SourceNode res
) {
  res = rn.getReceivedItem(i)
}
