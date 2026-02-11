/**
 * @kind path-problem
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow
private import utils.test.InlineFlowTest
private import codeql.ruby.dataflow.internal.DataFlowPrivate
private import codeql.ruby.dataflow.internal.DataFlowDispatch

query predicate nodeType(DataFlow::Node node, DataFlowType tp) {
  tp = getNodeType(node) and
  not tp.isUnknown()
}

private predicate isSource(DataFlow::Node source, string s) {
  exists(MethodCall taint, MethodCall new |
    taint.getMethodName() = "taint" and
    new.getMethodName() = "new" and
    source.asExpr().getExpr() = new and
    new = taint.getAnArgument() and
    s = new.getAnArgument().getConstantValue().toString()
  )
  or
  exists(SelfVariableAccess self, Module m |
    self = source.asExpr().getExpr() and
    not self.isSynthesized() and
    selfInMethod(self.getVariable(), _, m) and
    s = "self(" + m.getQualifiedName() + ")"
  )
}

private module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSource(source, _) }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc | mc.getMethodName() = "sink" |
      sink.asExpr().getExpr() = mc.getAnArgument()
    )
  }
}

bindingset[src, sink]
pragma[inline_late]
string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  isSource(src, result) and exists(sink)
}

import ValueFlowTestArgString<FlowConfig, getArgString/2>
import PathGraph

from PathNode source, PathNode sink
where flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()
