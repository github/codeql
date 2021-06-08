import javascript
import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

query predicate callGraph(DataFlow::InvokeNode node, Function callee) {
  FlowSteps::calls(node, callee)
}

query predicate moduleImport(DataFlow::SourceNode imp, string name) {
  imp = Closure::moduleImport(name)
}

query predicate nestedAccess(DataFlow::SourceNode imp) {
  imp = Closure::moduleImport("foo.bar.x.y.z")
}

query predicate strictMode(TopLevel tl, File file) { tl.isStrict() and file = tl.getFile() }

query predicate uri(DataFlow::SourceNode imp) { imp = Closure::moduleImport("goog.net.Uri") }
