private import unified
private import codeql.unified.internal.mad.LegacyMaD

query predicate isSource(DataFlow::Node node, string kind) {
  Models::isSource(node, kind) and
  node.getLocation().getFile().fromSource()
}

query predicate isSink(DataFlow::Node node, string kind) {
  Models::isSink(node, kind) and
  node.getLocation().getFile().fromSource()
}

query predicate constructor(CallExpr call, string type) {
  call = type.(TypeSelector).getAConstructorCall()
}
