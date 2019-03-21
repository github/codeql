import javascript

query predicate test_ClientSocketNode(SocketIOClient::SocketNode sn, string res) {
  res = sn.getNamespacePath()
}
