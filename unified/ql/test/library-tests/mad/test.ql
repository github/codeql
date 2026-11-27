private import unified

query predicate isSource(DataFlow::Node node, string kind) {
  Models::isSource(node, kind) and
  node.getLocation().getFile().fromSource()
}

query predicate isSink(DataFlow::Node node, string kind) {
  Models::isSink(node, kind) and
  node.getLocation().getFile().fromSource()
}
