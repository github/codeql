import javascript

query predicate test_query12(MethodCallExpr send) {
  exists(SimpleParameter res, DataFlow::Node resNode |
    res.getName() = "res" and
    resNode = DataFlow::parameterNode(res) and
    resNode.getASuccessor+() = DataFlow::valueNode(send.getReceiver()) and
    send.getMethodName() = "send"
  |
    any()
  )
}
