import javascript

query predicate test_ClientReceiveNode_getEventName(SocketIOClient::ReceiveNode rn, string res) {
  res = rn.getChannel()
}
