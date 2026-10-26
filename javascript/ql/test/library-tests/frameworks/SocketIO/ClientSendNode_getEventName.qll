import javascript

query predicate test_ClientSendNode_getEventName(SocketIOClient::SendNode sn, string res) {
  res = sn.getChannel()
}
