import javascript

query predicate test_ServerObject(
  SocketIO::ServerObject srv, DataFlow::SourceNode res0, SocketIO::NamespaceObject res1
) {
  res0 = srv and res1 = srv.getDefaultNamespace()
}
