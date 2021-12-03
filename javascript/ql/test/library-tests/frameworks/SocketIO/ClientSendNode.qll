import javascript

query predicate test_ClientSendNode(
  SocketIOClient::SendNode sn, SocketIOClient::SocketNode res0, string res1
) {
  res0 = sn.getSocket().ref() and res1 = sn.getNamespacePath()
}
