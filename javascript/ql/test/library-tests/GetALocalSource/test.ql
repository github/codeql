import javascript

string nodeName(DataFlow::SourceNode node) {
  result = node.getAstNode().(VarRef).getName()
  or
  result = node.getAstNode().(PropertyPattern).getName()
  or
  result = node.getAstNode().(PropAccess).getPropertyName()
  or
  exists(DataFlow::InvokeNode invoke |
    node = invoke and
    invoke.getCalleeName() = "source" and
    result = invoke.getArgument(0).getStringValue()
  )
}

bindingset[node1, node2]
pragma[inline_late]
predicate sameLine(DataFlow::Node node1, DataFlow::Node node2) {
  node1.getLocation().getFile() = node2.getLocation().getFile() and
  node1.getLocation().getStartLine() = node2.getLocation().getStartLine()
}

query predicate getALocalSource(DataFlow::Node node, string name) {
  exists(DataFlow::SourceNode sn |
    sn = node.getALocalSource() and
    name = nodeName(sn) and
    not sameLine(node, sn)
  )
}
