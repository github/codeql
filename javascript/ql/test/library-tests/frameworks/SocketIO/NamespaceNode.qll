import javascript

query predicate test_NamespaceNode(SocketIO::NamespaceNode ns, SocketIO::NamespaceObject res) {
  res = ns.getNamespace()
}
