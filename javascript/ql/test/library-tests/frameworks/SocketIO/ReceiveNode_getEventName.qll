import javascript

query predicate test_ReceiveNode_getEventName(SocketIO::ReceiveNode rn, string res) {
  res = rn.getChannel()
}
