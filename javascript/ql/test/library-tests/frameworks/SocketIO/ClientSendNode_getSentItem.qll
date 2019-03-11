import javascript

query predicate test_ClientSendNode_getSentItem(
  SocketIOClient::SendNode sn, int i, DataFlow::Node res
) {
  res = sn.getSentItem(i)
}
