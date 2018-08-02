import javascript

from SimpleParameter res, DataFlow::Node resNode, MethodCallExpr send
where res.getName() = "res" and
      resNode = DataFlow::parameterNode(res) and
      resNode.getASuccessor+() = DataFlow::valueNode(send.getReceiver()) and
      send.getMethodName() = "send"
select send
