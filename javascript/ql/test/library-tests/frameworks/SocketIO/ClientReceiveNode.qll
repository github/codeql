import javascript

query predicate test_ClientReceiveNode(
  SocketIOClient::ReceiveNode rn, SocketIOClient::SocketNode res
) {
  res = rn.getSocket().ref()
}
