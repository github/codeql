import javascript

query predicate test_ServerNode(SocketIO::ServerNode srv, SocketIO::ServerObject res) {
  res = srv.getServer()
}
