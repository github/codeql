/**
 * Defines the default source and sink recognition for `InlineFlowTest.qll`.
 *
 * We reuse these predicates in some type-tracking tests that don't wish to bring in the
 * test configuration from `InlineFlowTest`.
 */

import codeql.ruby.AST
import codeql.ruby.DataFlow

predicate defaultSource(DataFlow::Node src) {
  src.asExpr().getExpr().(MethodCall).getMethodName() = ["source", "taint"]
}

predicate defaultSink(DataFlow::Node sink) {
  exists(MethodCall mc | mc.getMethodName() = "sink" | sink.asExpr().getExpr() = mc.getAnArgument())
}

string getSourceArgString(DataFlow::Node src) {
  defaultSource(src) and
  src.asExpr().getExpr().(MethodCall).getAnArgument().getConstantValue().toString() = result
}
