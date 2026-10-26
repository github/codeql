import javascript

query predicate test_SocketNode(SocketIO::SocketNode sn, SocketIO::NamespaceObject res) {
  res = sn.getNamespace()
}
