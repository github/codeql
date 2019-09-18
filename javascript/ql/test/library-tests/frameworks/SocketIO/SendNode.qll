import javascript

query predicate test_SendNode(SocketIO::SendNode sn, SocketIO::NamespaceObject res) {
  res = sn.getNamespace()
}
