import javascript

query predicate test_ClientReceiveNode_getReceivedItem(
  SocketIOClient::ReceiveNode rn, int i, DataFlow::SourceNode res
) {
  res = rn.getReceivedItem(i)
}
