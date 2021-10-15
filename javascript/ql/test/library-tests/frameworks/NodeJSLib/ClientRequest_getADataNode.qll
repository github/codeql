import javascript

query predicate test_ClientRequest_getADataNode(
  NodeJSLib::NodeJSClientRequest cr, DataFlow::Node res
) {
  res = cr.getADataNode()
}
