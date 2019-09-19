import javascript

query predicate test_ClientRequest(ClientRequest r) { any() }

query predicate test_getADataNode(ClientRequest r, DataFlow::Node node) { node = r.getADataNode() }

query predicate test_getHost(ClientRequest r, DataFlow::Node node) { node = r.getHost() }

query predicate test_getUrl(ClientRequest r, DataFlow::Node node) { node = r.getUrl() }

query predicate test_getAResponseDataNode(
  ClientRequest r, DataFlow::Node node, string responseType, boolean promise
) {
  node = r.getAResponseDataNode(responseType, promise)
}
