import codeql.ruby.ast.Variable
import codeql.ruby.dataflow.internal.DataFlowPrivate::VariableCapture::Flow::ConsistencyChecks

query predicate ambiguousVariable(VariableAccess access, Variable variable) {
  access.getVariable() = variable and
  count(access.getVariable()) > 1
}
